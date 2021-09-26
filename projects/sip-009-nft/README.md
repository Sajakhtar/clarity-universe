# SIP009 NFT Contract

## Description

A simple SIP009 Compliant NFT Contract.

___
## Features
- Implements [SIP-009: Standard Trait Definition for Non-Fungible Tokens](https://github.com/stacksgov/sips/blob/main/sips/sip-009/sip-009-nft-standard.md).
- A public function count-up that increments the counter for tx-sender.

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


To check the count of the current `tx-sender` if it's the deployer, there is no need to specify the contract address:
```clarity
(contract-call? .counter get-count tx-sender)
```

___
## Unit Tests

No unit tests for this project as of yet.

Run unit tests in the terminal via the following command

```bash
clarinet test
```
