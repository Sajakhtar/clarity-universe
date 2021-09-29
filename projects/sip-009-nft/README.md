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

The Clarinet Console will be used to interact with the contract to mint NFTs and transfer them.


In the Clarinet Console, the contract deployer is the current `tx-sender`, which is the very first of the 10 test addresses the console provides. To check the current `tx-sender`
```clarity
tx-sender
```

You can change tx-sender to a different Principal from the test addresses in the Clarinet console e.g. to wallet_1
```clarity
::set_tx_sender STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6
```

We cna check the balance of the contracts and principals in the Clarinet console session:
```clarity
::get_assets_maps
```

Check block-height
```clarity
block-height
```

Simulate mining to set block-height to the unlock-height of u10
```clarity
::advance_chain_tip 10
```

We can call the `mint` function in the NFT contract with the default tx-sender, who is also the contract deployer
```clarity
(contract-call? .saj-nft mint tx-sender)
```

We can check the `token-id` of the last minted NFT.
```clarity
(contract-call? .saj-nft get-last-token-id)
```

We can transfer the NFT just minted to another pricipal, e.g. wallet_9.  We can check the new owner using `::get_assets_maps`.
```clarity
(contract-call? .saj-nft transfer u1 tx-sender 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)
```

We can check the owner of an NFT based on the `token-id`.
```clarity
(contract-call? .saj-nft get-owner u1)
```
We can fetch the meta-data URL for an NFT based on the `token-id`.
```clarity
(contract-call? .saj-nft get-token-uri u1)
```

Since the current `tx-sender` is not the owner of the NFT, we can attempt to transfer it back to the `tx-sender` (delpyer's) address to get `err-not-token-owner` `u101` error.
```clarity
(contract-call? .saj-nft transfer u1 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 tx-sender)
```

We can change the `tx-sender` to a principal that is not the contract deployer e.g. wallet_9 and run the `mint` function again to receive the `err-contract-owner-only` `u100` error.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.saj-nft mint tx-sender)
```

Since wallet_9 is the owner of NFT with ID `u1` and is the current `tx-sender`, we can call the `transfer` function and send the NFT to another address e.g. wallet_1. We can check the new owner using `::get_assets_maps`.
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.saj-nft transfer u1 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
```
___
## Unit Tests

No unit tests for this project as of yet.

Run unit tests in the terminal via the following command

```bash
clarinet test
```
