# Contents
1. [Timelocked Wallet Contract](#timelocked-wallet-contract)
1. [Smart Claimant Contract](#smart-claimant-contract)

___
# Timelocked Wallet Contract

## Description

Block height can be used to perform actions over time.

If you know the average block time, then you can calculate roughly how many blocks will be mined in a specific time frame.

The timelocked wallet contract will unlock at a specific block height.

Such a contract can be useful if you want to bestow tokens to someone after a certain time period.

Use case: imagine that in the crypto-future you want to put some money aside for when your child comes of age.
___
## Features

- A user can deploy the time-locked wallet contract.
- Then, the user specifies a block height at which the wallet unlocks and a beneficiary.
- Anyone, not just the contract deployer, can send tokens to the contract.
- The beneficiary can claim the tokens once the specified block height is reached.
- Additionally, the beneficiary can transfer the right to claim the wallet to a different principal.
___
## Public Functions

- `lock` - takes the principal, unlock height, and an initial deposit amount.
- `claim`- transfers the tokens to the tx-sender if and only if the unlock height has been reached and the tx-sender is equal to the beneficiary.
- `bestow` - allows the beneficiary to transfer the right to claim the wallet.

___
## Code Check

Check code for errors using the following in the terminal

```bash
clarinet check
```
___
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
___
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
___
# Smart Claimant Contract

## Description

A minimal ad hoc smart contract to act as the beneficiary of the Timelocked Wallet contract. It will call claim, and if successful, disburse the tokens to a list of principals equally.

Use case is that the beneficiary wants to share with other people. We cannot simply go back and change or redeploy the time-locked wallet, so we add a new contract to interact with it.

Clarity is well-suited for creating small ad hoc smart contracts.

Instead of coming up with a complicated mechanism for adding and removing beneficiaries, it will be kept simple by imagining that the people that are supposed to receive a portion of the balance are in the same room and that the wallet is unlocking imminently. They witness the creation of the contract by the current beneficiary and provide their wallet addresses directly.

Take wallets 1 to 4 as defined in the Clarinet configuration as the new beneficiaries.

The address for Wallets 1 to 4 in the Clainet console session are:
|Address|Wallet|
|--|--|
| ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 | wallet_1 |
| ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG | wallet_2 |
| ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC | wallet_3 |
| ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND | wallet_4 |

___
## Features

The custom claim function will:
- Call claim on the time-locked wallet, exiting if it fails.
- Read the balance of the current contract.
  - We do not read the balance of the time-locked wallet because someone might have sent some tokens to the smart-claimant by mistake.
  - We want to include those tokens as well.
- Calculate an equal share for each recipient by dividing the total balance by the number of recipients.
- Send the calculated share to each recipient.
- Transfer the remainder in case of a rounding error (integers have no decimal point).

___
## Code Check

Check code for errors using the following in the terminal

```bash
clarinet check
```
___
## Manual testing in Clarinet Console

Open the Clarinet Console within the terminal

```bash
clarinet console
```

In the Clarinet Console, the contract deployer is the current `tx-sender`, which is the very first of the 10 test addresses the console provides.

Note that Clarinet console sessions start at block `u0`.

___
## Unit Tests


Unit tests are writted in TypeScript.

For the counter contract, the test are writted in `tests/smart-claimant_test.ts`.

Tests are defined using the `Clarinet.test()` function.

Tests should cover both success and failure sates.

Tests should be kept as simple as possible - each test should check **one** aspect of a function.

Clarinet has built-in assertion functions to check if an expected STX transfer event actually happened.

The **Smart Claimant contract** does not care for what reason the time-locked wallet would error out. We therefore only need to consider the state of a successful transfer.
