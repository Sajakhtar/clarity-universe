
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

// Testing lock
//

Clarinet.test({
  name: "Allows the contract owner to lock an amount",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const beneficiary = accounts.get('wallet_1')!;
    const amount = 10;
    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(amount)], deployer.address)
    ]);

    // The lock should be successful
    block.receipts[0].result.expectOk().expectBool(true);

    // There should be a STX transfer of the amount specified
    block.receipts[0].events.expectSTXTransferEvent(amount, deployer.address, `${deployer.address}.timelocked-wallet`);
  }
});

Clarinet.test({
  name: "Does not allow anyone else to lock an amount",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const notDeployer = accounts.get('wallet_1')!;;
    const beneficiary = accounts.get('wallet_2')!;
    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(10)], notDeployer.address)
    ]);

    // Should return err-owner-only (err u100)
    block.receipts[0].result.expectErr().expectUint(100);
  }
});

Clarinet.test({
  name: "Cannot be locked more than once",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const beneficiary = accounts.get('wallet_1')!;
    const amount = 10;
    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(amount)], deployer.address),
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(amount)], deployer.address)
    ]);

    // The first lock worked and STX were transferred
    block.receipts[0].result.expectOk().expectBool(true);
    block.receipts[0].events.expectSTXTransferEvent(amount, deployer.address, `${deployer.address}.timelocked-wallet`);

    // The second lock fails with err-already-locked (err u101).
    block.receipts[1].result.expectErr().expectUint(101);

    // Assert there are no transfer events.
    assertEquals(block.receipts[1].events.length, 0);
  }
});

Clarinet.test({
  name: "Cannot set the unlock height to a value less than the current block height (Unlock height cannot be in the past)",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const beneficiary = accounts.get('wallet_1')!;
    const amount = 10;
    const targetBlockHeight = 10;

    // Advance the chain until the unlock height plus one
    chain.mineEmptyBlockUntil(targetBlockHeight + 1);

    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(targetBlockHeight), types.uint(amount)], deployer.address)
    ]);

    // lock fails with err-unlock-in-past (err u102)
    block.receipts[0].result.expectErr().expectUint(102);

    // Assert there are no transfer events
    assertEquals(block.receipts[0].events.length, 0);
  }
});

// Testing bestow
//

Clarinet.test({
  name: "Allows the beneficiary to bestow the right to claim to someone else",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const beneficiary = accounts.get('wallet_1')!;
    const newBeneficiary = accounts.get('wallet_2')!;
    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(10)], deployer.address),
      Tx.contractCall('timelocked-wallet', 'bestow', [types.principal(newBeneficiary.address)], beneficiary.address)
    ]);

    // Both results are (ok true)
    block.receipts.map(({ result }) => result.expectOk().expectBool(true));
  }
});

Clarinet.test({
  name: "Does not allow anyone else to bestow the right to claim to someone else (Not even the contract owner)",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const beneficiary = accounts.get('wallet_1')!;
    const badActor = accounts.get('wallet_3')!;
    const block = chain.mineBlock([
      Tx.contractCall('timelocked-wallet', 'lock', [types.principal(beneficiary.address), types.uint(10), types.uint(10)], deployer.address),
      Tx.contractCall('timelocked-wallet', 'bestow', [types.principal(deployer.address)], deployer.address),
      Tx.contractCall('timelocked-wallet', 'bestow', [types.principal(badActor.address)], badActor.address)
    ]);

    // All but the first call fails with err-beneficiary-only (err u104).
    block.receipts.slice(1).map(({result}) => result.expectErr().expectUint(104))
  }
});


// Testing claim
//
Clarinet.test({
  name: "Does not allow anyone else to bestow the right to claim to someone else (Not even the contract owner)",
  async fn(chain: Chain, accounts: Map<string, Account>) {

  }
});

// Allows the beneficiary to claim the balance when the block height is reached.
// Does not allow the beneficiary to claim the balance before the block - height is reached.
// Nobody but the beneficiary can claim the balance once the block height is reached.
