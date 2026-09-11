mod pb {
    pub mod demo {
        pub mod usdc {
            pub mod v1 {
                include!(concat!(env!("OUT_DIR"), "/demo.usdc.v1.rs"));
            }
        }
    }

    pub mod sf {
        pub mod substreams {
            pub mod sink {
                pub mod entity {
                    pub mod v1 {
                        include!(concat!(env!("OUT_DIR"), "/sf.substreams.sink.entity.v1.rs"));
                    }
                }
            }
        }
    }
}

use pb::demo::usdc::v1::{UsdcTransfer, UsdcTransfers};
use pb::sf::substreams::sink::entity::v1::entity_change::Operation;
use pb::sf::substreams::sink::entity::v1::value::Typed;
use pb::sf::substreams::sink::entity::v1::{EntityChange, EntityChanges, Field, Value};
use substreams::errors::Error;
use substreams::scalar::BigInt;
use substreams::Hex;
use substreams_ethereum::pb::eth::v2::Block;

const USDC_ADDRESS: [u8; 20] = hex_literal::hex!("a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48");
const TRANSFER_TOPIC: [u8; 32] =
    hex_literal::hex!("ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef");

fn address_from_topic(topic: &[u8]) -> Option<String> {
    let address = topic.get(12..32)?;
    Some(format!("0x{}", Hex::encode(address)))
}

fn value(typed: Typed) -> Option<Value> {
    Some(Value { typed: Some(typed) })
}

fn field(name: &str, new_value: Option<Value>) -> Field {
    Field {
        name: name.to_string(),
        new_value,
        old_value: None,
    }
}

#[substreams::handlers::map]
pub fn map_usdc_transfers(block: Block) -> Result<UsdcTransfers, Error> {
    let mut transfers = Vec::new();

    for transaction in block.transactions() {
        let tx_hash = format!("0x{}", Hex::encode(&transaction.hash));

        for (log, _) in transaction.logs_with_calls() {
            if log.address.as_slice() != USDC_ADDRESS.as_slice()
                || log.topics.len() != 3
                || log.topics[0].as_slice() != TRANSFER_TOPIC.as_slice()
                || log.data.len() != 32
            {
                continue;
            }

            let (Some(from), Some(to)) = (
                address_from_topic(&log.topics[1]),
                address_from_topic(&log.topics[2]),
            ) else {
                continue;
            };

            transfers.push(UsdcTransfer {
                from,
                to,
                amount: BigInt::from_unsigned_bytes_be(&log.data).to_string(),
                tx_hash: tx_hash.clone(),
                log_index: log.index as u64,
                block_number: block.number,
            });
        }
    }

    Ok(UsdcTransfers { transfers })
}

#[substreams::handlers::map]
pub fn graph_out(transfers: UsdcTransfers) -> Result<EntityChanges, Error> {
    let entity_changes = transfers
        .transfers
        .into_iter()
        .map(|transfer| EntityChange {
            entity: "UsdcTransfer".to_string(),
            id: format!("{}-{}", transfer.tx_hash, transfer.log_index),
            ordinal: 0,
            operation: Operation::Create as i32,
            fields: vec![
                field("from", value(Typed::String(transfer.from))),
                field("to", value(Typed::String(transfer.to))),
                field("amount", value(Typed::Bigint(transfer.amount))),
                field("transactionHash", value(Typed::String(transfer.tx_hash))),
                field(
                    "logIndex",
                    value(Typed::Bigint(transfer.log_index.to_string())),
                ),
                field(
                    "blockNumber",
                    value(Typed::Bigint(transfer.block_number.to_string())),
                ),
            ],
        })
        .collect();

    Ok(EntityChanges { entity_changes })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn decodes_abi_address_topic() {
        let topic =
            hex_literal::hex!("0000000000000000000000001111111111111111111111111111111111111111");
        assert_eq!(
            address_from_topic(&topic).as_deref(),
            Some("0x1111111111111111111111111111111111111111")
        );
    }
}
