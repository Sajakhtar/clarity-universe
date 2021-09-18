
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';


// Testing get-count
Clarinet.test({
  name: "get-count returns u0 for principals that never called count-up before",
  async fn(chain: Chain, accounts: Map<string, Account>) {

    // Get the deployer account
    let deployer = accounts.get('deployer')!;

    // Call the get-count read-only function.
    // The first parameter is the contract name, the second the
    // function name, and the third the function arguments as
    // an array. The final parameter is the tx-sender.
    let count = chain.callReadOnlyFn('counter', 'get-count', [types.principal(deployer.address)], deployer.address);

    // Assert that the returned result is a uint with a value of 0 (u0).
    count.result.expectUint(0);

  }
})


// Testing count-up
Clarinet.test({
  name: "count-up counts up for the tx-sender",
  async fn(chain: Chain, accounts: Map<string, Account>) {

    // Get the deployer account
    let deployer = accounts.get('deployer')!;

    // Mine a block with one transaction
    let block = chain.mineBlock([
      // contract call to count-up from delpoyer address
      Tx.contractCall('counter', 'count-up', [], deployer.address)
    ]);

    // Get the first (and only) transaction receipt
    let [receipt] = block.receipts;

    // Assert result is boolean true
    receipt.result.expectOk().expectBool(true);

    // Get the counter value
    let count = chain.callReadOnlyFn('counter', 'get-count', [types.principal(deployer.address)], deployer.address);

    // Assert the returned results is u1
    count.result.expectUint(1);

  }
});


// Testing the multiplayer aspect
