#!/usr/bin/env bash
# Run once after deploying a new contract: initialize and whitelist the investor.
set -euo pipefail

NETWORK="${NETWORK:-testnet}"
ADMIN_KEY="${ADMIN_KEY:?Set ADMIN_KEY to your funded Stellar CLI identity}"
CONTRACT_ID="${CONTRACT_ID:?Set CONTRACT_ID to the newly deployed launchpad contract}"
PAYMENT_TOKEN="${PAYMENT_TOKEN:?Set PAYMENT_TOKEN to a real funded payment token contract}"
INVESTOR="${INVESTOR:?Set INVESTOR to the investor's public address}"
ASSET_JSON="$(printf '{"name":"RWAToken","total_supply":1000000,"price_per_unit":100,"payment_token":"%s","paused":false}' "$PAYMENT_TOKEN")"

echo "=== initialize (only once per new contract) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" --source "$ADMIN_KEY" --network "$NETWORK" -- \
  initialize \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --asset "$ASSET_JSON"

echo "=== whitelist investor ==="
stellar contract invoke \
  --id "$CONTRACT_ID" --source "$ADMIN_KEY" --network "$NETWORK" -- \
  set_whitelist \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --investor "$INVESTOR" \
  --approved true
