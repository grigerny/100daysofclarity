
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.3.1/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that <...>",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let block = chain.mineBlock([
            /*
             * Add transactions with:
             * Tx.contractCall(...)
            */
        ]);
        assertEquals(block.receipts.length, 0);
        assertEquals(block.height, 2);

        block = chain.mineBlock([
            /*
             * Add transactions with:
             * Tx.contractCall(...)
            */
        ]);
        assertEquals(block.receipts.length, 0);
        assertEquals(block.height, 3);
    },
});

Clarinet.test({

    name: "Get nonexistent child wallet, return none",
    async fn(chain: Chain, accounts: Map<string, Account>) {

        
        let deploy = accounts.get("deployer")!;
        let wallet_1 = accounts.get("wallet_1")!;
        // All functions to test

        let readResult = chain.callReadOnlyFn("offspring-will", "get-child-wallet", [types.principal(wallet_1.address)], deploy.address);
        
        readResult.result.expectNone();
    
    },
})