FactoryBot.define do
  factory :uncle_block do
    difficulty { "0x100" }
    block_hash { "0xf6d9c070dfebb30eeb685d74836e7c7dcf82b61ef8214a769f50d9fa8b4ed783" }
    number { 7 }
    parent_hash { "0xe20604d760b8d13d76608fe74653554e727f81186697d976707d589a36948a59" }
    seal { { "nonce" => 1757392074788233522, "proof" => "0x5900000098000000d90e00004b110000de1500001b25000051380000973d00001e490000194c00003760000012680000" } }
    timestamp { 1554100447138 }
    txs_commit { "0x1d82a6d7bcefca69be3f2c7e43f88a18f4fd01eb05d06f4d2fe2df8a8afb350f" }
    txs_proposal { "0x0000000000000000000000000000000000000000000000000000000000000000" }
    uncles_count { 1 }
    uncles_hash { "0x0000000000000000000000000000000000000000000000000000000000000000" }
    version { 0 }
    proposal_transactions {  }
    proposal_transactions_count { 0 }
  end
end