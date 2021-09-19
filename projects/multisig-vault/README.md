# The Multi-signature Vault

## Description

Blockchain enables us to decentralise more than just digital asset management, such as decentralised governance i.e. voting.

Traditionally participants cannot verify whether the process is fair or that the results are genuine.

DAOs (Decentralised Autonomous Organisations) fixes this.

A DAO is a smart contract that organises some type of decision-making power, usually on behalf of its members.

DAOs can be very complex, featuring multiple levels of management, asset delegation, and member management.

This project will be a simplified DAO that allows its members to vote on which principal is allowed to withdraw the DAO's token balance.

The DAO will be initialised once when it's deployed, after which members can vote in favour or against specific principals.

___
## Features

- The contract deployer will only have the ability to initialise the contract and will then run its course.
- The initialising call will define the members (a list of principals) and the number of votes required to be allowed to withdraw the balance.
- The voting mechanism will work as follows:
  - Members can issue a yes/no vote for any principal.
  - Voting for the same principal again replaces the old vote.
  - Anyone can check the status of a vote.
  - Anyone can tally all the votes for a specific principal.
- Once a principal reaches the number of votes required, it may withdraw the tokens.

___
## Public Functions

- `start` - The start function will be called by the contract owner to initialise the vault; it's a simple function that updates the two variables with the proper guards in place.
- `vote` -
- `get-vote` -
- `tally` -
- `withdraw` -
- `deposit` -

___
## Code Check

Check code for errors using the following in the terminal

```bash
clarinet check
```

___
## Unit Tests

Unit tests are writted in TypeScript.

For the counter contract, the test are writted in `tests/timelocked-wallet_test.ts`.

Tests are defined using the `Clarinet.test()` function.

Tests should cover both success and failure sates.

Tests should be kept as simple as possible - each test should check **one** aspect of a function.

Clarinet has built-in assertion functions to check if an expected STX transfer event actually happened.

For the **Multisig Vault contract** we want to check that
- lock function
  - something



Run unit tests in the terminal via the following command

```bash
clarinet test
```
___
