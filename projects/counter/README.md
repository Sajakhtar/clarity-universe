# Counter Contract


## Description

A Multi-pricinpal counter contract.

## Features
- A data store (map) that keeps a track of the count per principal.
- A public function count-up that increments the counter for tx-sender.
- A public function get-count that returns the current counter value for the passed principal.

## To Test

Open the Clarinet Console within the terminal

```bash
clarinet console
```

In the Clarinet Console, the contract deployer is the current `tx-sender`, which is the very first of the 10 test addresses the console provides.


To check the count of the current `tx-sender` if it's the deployer, there is no need to specify the contract address:
```bash
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
