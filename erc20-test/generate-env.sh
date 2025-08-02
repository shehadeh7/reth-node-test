#!/usr/bin/env bash
set -e

MNEMONIC="test test test test test test test test test test test junk"
NUM_ACCOUNTS=${1:-5}   # default to 5 accounts if no arg provided
DERIVATION_BASE="m/44'/60'/0'/0"
ENV_FILE=".env"

echo "Generating $ENV_FILE for $NUM_ACCOUNTS accounts..."
echo "" > $ENV_FILE

for i in $(seq 0 $((NUM_ACCOUNTS-1))); do
    DERIVATION_PATH="${DERIVATION_BASE}/${i}"

    # Derive private key using mnemonic and full derivation path as positional arg
    privkey=$(cast wallet private-key "$MNEMONIC" "$DERIVATION_PATH")

    # Get address from private key
    address=$(cast wallet address --private-key "$privkey")

    echo "ACCOUNT_${i}_ADDRESS=$address" >> $ENV_FILE
    echo "ACCOUNT_${i}_PRIVATE_KEY=$privkey" >> $ENV_FILE
done

echo "✅ Generated $ENV_FILE with $NUM_ACCOUNTS accounts."
