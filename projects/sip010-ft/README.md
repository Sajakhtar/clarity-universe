# SIP010 Fungible Token (FT) Contract

## Description

A simple SIP010 Compliant Fungible Token (FT) Contract.

___
## Features
- Implements [SIP010: Standard Trait Definition for Fungible Tokens](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
- SIP010 specifies the following functions for FTs
  - `transfer`: transfers tokens from `sender` to a new principal
    - asserts that the `sender` equals `tx-sender` so principals can only transfer tokens they own
    - It should also unwrap and print the memo if it is not none (we use match to conditionally call print if the passed memo is a some)
  - `get-name`: returns the human readable name of the token
  - `get-symbol`: returns the ticker sumbol, or none
  - `get-decimals`: returns the number decimals used e.g. 6 would mean 1_000_000 represents 1 token
  - `get-balance`: returns the balance of the passed principal
    - We simply wrap the built-in function `ft-get-balance` that retrieves the balance
  - `get-total-supply`: the current total supply (which does not need to be a constant)
    - - We simply wrap the built-in function `ft-get-supply` that retrieves the balance
  - `get-token-uri`: return an optional URI that represents metadata of this token
- `mint`: for our convenience to mint FTs using the built-in `ft-mint?` function
  - we have a guard (assert) here to only allow the contract owner to mint FTs
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

The Clarinet Console will be used to interact with the contract to mint FTs and transfer them.


In the Clarinet Console, the contract deployer is the current `tx-sender`, which is the very first of the 10 test addresses the console provides. To check the current `tx-sender`
```clarity
tx-sender
```

You can change tx-sender to a different Principal from the test addresses in the Clarinet console e.g. to wallet_9
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

We can call the `mint` function in the FT contract with the default tx-sender, who is also the contract deployer, to min 1000 tokens. We can check the minted tokens now belong to the contract deployer using `::get_assets_maps`.
```clarity
(contract-call? .saj-coin mint u1000 tx-sender)
```

We can check the friendly name of FT.
```clarity
(contract-call? .saj-coin get-name)
```

We can check the ticker name of FT.
```clarity
(contract-call? .saj-coin get-symbol)
```

We can check the decimal places allowed for the FT.
```clarity
(contract-call? .saj-coin get-decimals)
```

```
We can fetch the meta-data URL for an FT.
```clarity
(contract-call? .saj-coin get-token-uri)
```

We can check the total supply of FT.
```clarity
(contract-call? .saj-coin get-total-supply)
```

We can check the the FT balance for the deployer.
```clarity
(contract-call? .saj-coin get-balance tx-sender)
```

We can transfer some of the token just minted to another pricipal, e.g. wallet_9.  We can check the balance of tokens for each principal using `::get_assets_maps`.
```clarity
(contract-call? .saj-coin transfer u250 tx-sender 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 none)
```

We can check the the FT balance of wallet_9.
```clarity
(contract-call? .saj-coin get-balance 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)
```

We can transfer some of the token just minted to another pricipal, e.g. wallet_1, but this time with a memo.  We can check the balance of tokens for each principal using `::get_assets_maps`.
```clarity
(contract-call? .saj-coin transfer u200 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 (some 0x123456))
```


We can change the `tx-sender` to a principal that is not the contract deployer e.g. wallet_9 and run the `mint` function again for 2M tokens to receive the `err-contract-owner-only` `u100` error.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.saj-coin mint u2000000 tx-sender)
```

We can check the the FT balance for the deployer.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.saj-coin get-balance tx-sender)
```

We can change the `tx-sender` to a principal that doesnt not have sufficient balance to send tokens e.g. wallet_2, and try to send tokens to another principal e.g. wallet_8 to receive a `u1` error.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.saj-coin transfer u500 tx-sender 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP none)
```
___
## Unit Tests

No unit tests for this project as of yet.

Run unit tests in the terminal via the following command

```bash
clarinet test
```
