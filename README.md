# Micro DeFi Projects

A repository of micro DeFi projects undertaken to explore smart contract interactions.

## Project Structure

Visit the [test folder](./test/) which is organized per protocol. For instance, you can explore the [Uniswap v3 interactions](./test/uniswap-v3/).

*   [./test/uniswap-v3/](./test/uniswap-v3/) — Liquidity provisioning and swaps.
*   [./test/aave-v3/](./test/aave-v3/) — Flash loans and supply/borrow tests.
*   [./test/curve/](./test/curve/) — Stablecoin swapping and gauge staking.

## Getting Started

1. Make sure you have foundry installed and install dependencies: `forge build`
2. Run specific protocol tests: `forge test --fork-url $RPC_URL --mt test_FunctionName -vvvvv`
