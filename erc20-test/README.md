# Forge ERC-20 Project

This directory contains your Forge-based Solidity project for ERC-20 contract development and testing, integrated with a local [reth](https://github.com/paradigmxyz/reth) Ethereum node.

---

## Prerequisites

- [Foundry](https://getfoundry.sh/) installed (`forge` and `cast` commands available)
- A local **reth** node running and fully synced on RPC endpoint `http://127.0.0.1:8545`
- `bash` shell for running environment setup scripts

---

## Getting Started

### 1. Start your reth node

Make sure your local `reth` Ethereum node is running and listening on the default RPC port 8545:

```bash
cargo run -- node --dev --dev.block-time 12s
```

### 2. Generate accounts `.env` file
This project expects a .env file with your test accounts and private keys derived from the default mnemonic:
```bash
./generate-env.sh 5
```

This script will:
* Derive 5 accounts from mnemonic:
    `
  test test test test test test test test test test test junk
     `
* Output `.env` with keys like:
     ```makefile
        ACCOUNT_0_ADDRESS=0x...
        ACCOUNT_0_PRIVATE_KEY=0x...
        ACCOUNT_1_ADDRESS=0x...
        ACCOUNT_1_PRIVATE_KEY=0x...
     ```
* You can increase the number of accounts by changing the argument.

### 3. Build your contracts
Compile your Solidity contracts:
```bash
forge build
```

### 4. Run tests
Execute all tests under `test/` directory:
```bash
forge test
```

### 5. Run Forge scripts
```bash
forge script script/MyToken.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast
```

> Make sure to `source .env` before running

## Notes 
* Scripts use private keys from `.env` to sign transactions.
* Make sure the reth node is running before executing scripts.
* Use `cast` for auxiliary wallet commands (e.g., address, key derivation).

