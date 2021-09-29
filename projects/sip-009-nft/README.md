# SIP009 NFT Contract

## Description

A simple SIP009 Compliant NFT Contract.

___
## Features
- Implements [SIP009: Standard Trait Definition for Non-Fungible Tokens](https://github.com/stacksgov/sips/blob/main/sips/sip-009/sip-009-nft-standard.md)
- SIP009 specifies the following functions for NFTs
  - `get-last-token-id`: used to tracks the ID of the last NFT minted, usefule to set the ID of the next NFT to be minted
  - `get-token-uri`: to return a link to the metadata for the NFT content (this example will not have a link and will return `none`)
  - `get-owner`: returns the owner of the NFT by using the built-in function `nft-get-owner?`
  - `transfer`: asserts that `sender` equals `tx-sender` so that only the principal that owns the NFT can transfer it
- `mint`: for our convenience to mint NFTs using the built-in `nft-mint?` function
  - we have a guard (assert) here to only allow the contract owner to mint NFTs
  - we also increment the `last-token-id`


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
