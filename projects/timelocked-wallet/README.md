# Timelocked Wallet Contract

## Description

Block height can be used to perform actions over time.

If you know the average block time, then you can calculate roughly how many blocks will be mined in a specific time frame.

The timelocked wallet contract will unlock at a specific block height.

Such a contract can be useful if you want to bestow tokens to someone after a certain time period.

Use case: imagine that in the crypto-future you want to put some money aside for when your child comes of age.

## Features

- A user can deploy the time-locked wallet contract.
- Then, the user specifies a block height at which the wallet unlocks and a beneficiary.
- Anyone, not just the contract deployer, can send tokens to the contract.
- The beneficiary can claim the tokens once the specified block height is reached.
- Additionally, the beneficiary can transfer the right to claim the wallet to a different principal.

## Public Functions

- `lock` - takes the principal, unlock height, and an initial deposit amount.
- `claim`- transfers the tokens to the tx-sender if and only if the unlock height has been reached and the tx-sender is equal to the beneficiary.
- `bestow` - allows the beneficiary to transfer the right to claim the wallet.


## Code Check

Check code for errors using the following in the terminal

```bash
clarinet check
```

## Manual testing in Clarinet Console

Open the Clarinet Console within the terminal

```bash
clarinet console
```

In the Clarinet Console, the contract deployer is the current `tx-sender`, which is the very first of the 10 test addresses the console provides.

Note that Clarinet console sessions start at block `u0`.

Call `lock` and set beneficiary to `wallet_1`, `unlock-height` to `u10`, `amount` to  100 mSTX
```clarinet
(contract-call? .timelocked-wallet lock 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 u10 u100)
```

Check the balance of the contracts and principals in the Clarinet console session:
```clarinet
::get_assets_maps
```

Set the `tx-sender` to the beneficiary i.e. `wallet_1`
```clarinet
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
```

Check current `tx-sender`
```clarinet
tx-sender
```

Check `block-height`
```clarinet
block-height
```

Call `claim` as the correct beneficiary but with `block-height` < `unlock-height` to get `(err u105)`
```clarinet
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.timelocked-wallet claim)
```

Simulate mining to set `block-height` to the `unlock-height` of `u10`
```clarinet
::advance_chain_tip 10
```

Re-run the `claim` function and check the balance of the contracts and principals (asset maps)



## Unit Tests

Unit tests are writted in TypeScript.

For the counter contract, the test are writted in `tests/timelocked-wallet_test.ts`.

Tests are defined using the `Clarinet.test()` function.

Tests should cover both success and failure sates.

Tests should be kept as simple as possible - each test should check **one** aspect of a function.

Clarinet has built-in assertion functions to check if an expected STX transfer event actually happened.

For the **Timelocked Wallet contract** we want to check that
- lock function
  - Allows the contract owner to lock an amount
  - Does not allow anyone else to lock an amount
  - Cannot be locked more than once
  - Cannot set the unlock height to a value less than the current block height
  - Contract owner cannot lock with zero amount
- bestow function
  - Allows the beneficiary to bestow the right to claim to someone else
  - Does not allow anyone else to bestow the right to claim to someone else (not even the contract owner)
- claim function
  - Allows the beneficiary to claim the balance when the block height is reached
  - Does not allow the beneficiary to claim the balance before the block-height is reached
  - Nobody but the beneficiary can claim the balance once the block height is reached


Run unit tests in the terminal via the following command

```bash
clarinet test
```
