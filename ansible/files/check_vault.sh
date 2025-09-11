#!/usr/bin/env bash
VAULT_ADDR="${VAULT_ADDR:-http://10.0.0.10:8200}"
OUT=$(curl -s "${VAULT_ADDR}/v1/sys/health")
if [ -z "$OUT" ]; then
  echo "VAULT CRITICAL - no response"
  exit 2
fi
sealed=$(echo "$OUT" | jq -r '.sealed')
if [ "$sealed" = "true" ]; then
  echo "VAULT WARNING - sealed"
  exit 1
fi
echo "VAULT OK - unsealed"
exit 0
