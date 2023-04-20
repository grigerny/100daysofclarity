
import { Clarinet, Tx, Chain, Account, Contract, types } from 'https://deno.land/x/clarinet@v1.3.1/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that user can mint & stake",
    async fn(chain: Chain, accounts: Map<string, Account>) {

        let deployer = accounts.get("deployer")!;
        let wallet_1 = accounts.get ("wallet_1")!; 

        let mintBlock = chain.mineBlock([
            Tx.contractCall("nft-simple", "mint", [], deployer.address)
        ]);

        console.log(mintBlock.receipts[0].events)

        chain.mineEmptyBlock(1)

        let stakeBlock = chain.mineBlock([
            Tx.contractCall("staking-simple", "stake-nft", [types.uint(1)], deployer.address)
        ]);

        console.log(stakeBlock.receipts[0].events)
        stakeBlock.receipts[0].result.expectOk()

        // assertEquals(block.height, 3);
    },
});

Clarinet.test({
    name: "Ensure that user can mint NFTs & stake",
    async fn(chain: Chain, accounts: Map<string, Account>) {

        let deployer = accounts.get("deployer")!;
        let wallet_1 = accounts.get ("wallet_1")!; 

        let mintBlock = chain.mineBlock([
            Tx.contractCall("nft-simple", "mint", [], deployer.address)
        ]);

        console.log(mintBlock.receipts[0].events)

        chain.mineEmptyBlock(1)

        let stakeBlock = chain.mineBlock([
            Tx.contractCall("staking-simple", "stake-nft", [types.uint(1)], deployer.address)
        ]);

        console.log(stakeBlock.receipts[0].events)
        
        chain.mineEmptyBlocks(5)

        const getUnclaimedBalance = chain.callReadOnlyFn("staking-simple", "get-unclaimed-balance", [], deployer.address)

        console.log(getUnclaimedBalance)
        // assertEquals(block.height, 3);
    },
});