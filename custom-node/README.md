## Testing
1. Run the node using
```
cargo run -- node --dev
```

2. Note the RPC URL and dev accounts
3. Cast using the below command. Chain-id could be 1337 in dev mode
```
cast chain-id --rpc-url http://127.0.0.1:8545
```
4. Can also use forge test
```
forge test --rpc-url http://127.0.0.1:8545
```

