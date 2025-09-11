#!/usr/bin/env bash
# vault_upload.sh
#
# Simple helper to upload CA cert and CA private key to HashiCorp Vault (KV v2)
# Requirements:
# - vault CLI installed and authenticated (VAULT_ADDR and VAULT_TOKEN or 'vault login' done)
# - Files: path to CA cert and CA key (PEM)
#
# Usage:
#   ./scripts/vault_upload.sh --cert /path/to/ca.cert.pem --key /path/to/ca.key.pem --mount secret --path pki/ca
#
# Example:
#   export VAULT_ADDR='https://vault.example.local:8200'
#   export VAULT_TOKEN='s.xxxxx'
#   ./scripts/vault_upload.sh --cert ca/certs/ca.cert.pem --key ca/private/ca.key.pem
#
set -euo pipefail
CERT=""
KEY=""
MOUNT="secret"
PATH_IN_VAULT="pki/ca"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cert) CERT="$2"; shift 2;;
    --key) KEY="$2"; shift 2;;
    --mount) MOUNT="$2"; shift 2;;
    --path) PATH_IN_VAULT="$2"; shift 2;;
    -h|--help) echo "Usage: $0 --cert CA_CERT_PATH --key CA_KEY_PATH [--mount secret] [--path pki/ca]"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

if [[ -z "$CERT" || -z "$KEY" ]]; then
  echo "Error: --cert and --key are required"
  exit 2
fi

if ! command -v vault >/dev/null 2>&1; then
  echo "Error: vault CLI not found. Install from https://www.vaultproject.io/downloads"
  exit 3
fi

# Check VAULT env
if [[ -z "${VAULT_ADDR:-}" ]]; then
  echo "Warning: VAULT_ADDR not set. Using vault CLI default."
fi

if [[ -z "${VAULT_TOKEN:-}" ]]; then
  echo "Warning: VAULT_TOKEN not set. Ensure you're authenticated with 'vault login' or export VAULT_TOKEN."
fi

# Using KV v2: use `vault kv put` which handles v2 transparently for CLI when mount is 'secret'
# Put files as values
echo "Uploading CA certificate and private key to Vault at mount='$MOUNT' path='$PATH_IN_VAULT'..."
vault kv put "${MOUNT}/${PATH_IN_VAULT}" ca_cert="@${CERT}" ca_key="@${KEY}"
echo "Upload complete. Set proper policies to restrict access to the secret path."
echo "Example policy:"
echo "path \"${MOUNT}/${PATH_IN_VAULT}\" { policy = \"read\" }"
