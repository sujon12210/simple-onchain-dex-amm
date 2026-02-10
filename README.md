# Simple On-Chain DEX (AMM)

This repository provides a high-quality, educational implementation of an Automated Market Maker (AMM). It uses the Constant Product formula $x * y = k$ to allow trustless token swaps without a centralized order book.

## Core Mechanics
- **Liquidity Provision:** Users deposit a pair of tokens to receive LP (Liquidity Provider) tokens.
- **Automated Pricing:** The price of tokens shifts automatically based on the ratio of the reserves.
- **Swapping:** Users can swap Token A for Token B, paying a small fee that rewards liquidity providers.



## Features
- **Minimalist Logic:** Stripped down to the essentials for easier auditing and learning.
- **Slippage Protection:** Basic requirements to ensure users receive a fair amount of tokens.
- **Foundry Powered:** Full test coverage for swap logic and liquidity math.

## Tech Stack
- **Solidity ^0.8.20**
- **ERC-20 Interface**
- **Foundry**
