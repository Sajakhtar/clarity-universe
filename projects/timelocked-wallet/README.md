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

## Test in Clarinet Console

## Unit Tests
