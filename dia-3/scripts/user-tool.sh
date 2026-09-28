#!/usr/bin/env bash
# Run after the admin tool, with an investor funded with >=500 payment-token units.
set -euo pipefail

NETWORK="${NETWORK:-testnet}"
USER_KEY="${USER_KEY:?Set USER_KEY to the investor's funded Stellar CLI identity}"
CONTRACT_ID="${CONTRACT_ID:?Set CONTRACT_ID to the launchpad contract}"
INVESTOR="$(stellar keys address "$USER_KEY")"

echo "=== invest 100: expected AmountTooLow (#7) ==="
if stellar contract invoke \
  --id "$CONTRACT_ID" --source "$USER_KEY" --network "$NETWORK" -- \
  invest --investor "$INVESTOR" --payment_amount 100; then
  echo "ERROR: 100 was accepted; the minimum investment rule is not active." >&2
  exit 1
fi
echo "The transaction with 100 was rejected as expected."

echo "=== invest 500: expected success (5 RWA units at price 100) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" --source "$USER_KEY" --network "$NETWORK" -- \
  invest --investor "$INVESTOR" --payment_amount 500

echo "=== investor RWA balance: expected 5 for a fresh contract ==="
stellar contract invoke \
  --id "$CONTRACT_ID" --source "$USER_KEY" --network "$NETWORK" -- \
  balance --id "$INVESTOR"
