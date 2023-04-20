import { Clarinet, Tx, Chain, Account, Contract, types } from 'https://deno.land/x/clarinet@v1.3.1/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

// Clarinet.test({
//     name: "Ensure that the right amount of STX (NFT Price) is transferred",
//     async fn(chain: Chain, accounts: Map<string, Account>, Contracts: Map<string, Contract>) {
//        let deployer = accounts.get("deployer")!;
//        let wallet_1 = accounts.get("wallet_1")!;

//        let block = chain.mineBlock([
//            Tx.contractCall("nft-simple", "mint", [], wallet_1.address)
//        ]);

//        block.receipts[0].result.expectOk().expectBool(true);

//        console.log(block.receipts[0].events)

//        block.receipts[0].events.expectNonFungibleTokenMintEvent(
//            types.uint(1),
//            wallet_1.address,
//            '${deployer.address}.nft-simple',
//            "nft-simple"
//        )
           
//     }
// })

//     