#!/bin/bash
# Nagios check for Vault availability and health

VAULT_ADDR=${VAULT_ADDR:-"http://127.0.0.1:8200"}
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $VAULT_ADDR/v1/sys/health)

if [ "$STATUS" -eq 200 ]; then
  echo "VAULT OK - Vault is initialized, unsealed, and active."
  exit 0
elif [ "$STATUS" -eq 429 ]; then
  echo "VAULT WARNING - Vault is unsealed and standby."
  exit 1
elif [ "$STATUS" -eq 472 ]; then
  echo "VAULT CRITICAL - Vault is in recovery mode."
  exit 2
elif [ "$STATUS" -eq 501 ]; then
  echo "VAULT CRITICAL - Vault is not initialized."
  exit 2
elif [ "$STATUS" -eq 503 ]; then
  echo "VAULT CRITICAL - Vault is sealed."
  exit 2
else
  echo "VAULT UNKNOWN - Unable to determine Vault health (status code: $STATUS)."
  exit 3
fi
