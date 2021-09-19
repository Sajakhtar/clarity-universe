# Counter Contract

## Description

A Multi-principal counter contract.

___
## Features
- A data store (map) that keeps a track of the count per principal.
- A public function count-up that increments the counter for tx-sender.
- A public function get-count that returns the current counter value for the passed principal.

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

To check the count of the current `tx-sender` if it's **not** the deployer, the contract address must be specified e.g.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.counter get-count tx-sender)
```

To increment the transaction count of the current `tx-sender`, if it's the deployer
```clarity
(contract-call? .counter count-up)
```

To increment the transaction count of the current `tx-sender` if it's **not** the deployer, the contract address must be specified e.g.
```clarity
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.counter count-up)
```

You can change `tx-sender` to a different Principal from the test addresses in the Clarinet console e.g.

```clarity
::set_tx_sender ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK
```
Then you can check the count and increment the count for the new `tx-sender` principal using the method mentioned above.

___
## Unit Tests

Unit tests are writted in TypeScript.

For the counter contract, the test are writted in `tests/counter_test.ts`.

Tests are defined using the `Clarinet.test()` function.

Tests should cover both success and failure sates.

Tests should be kept as simple as possible - each test should check **one** aspect of a function.

For the **Counter contract** we want to check that
- `get-count` returns u0 for principals that have never called `count-up`.
- `get-count` returns the number of times (`uint`) a specific principal called `count-up`.
- `count-up` increments the counter for the `tx-sender` as observed by `get-count` and returns `(ok true)`.


Run unit tests in the terminal via the following command

```bash
clarinet test
```
