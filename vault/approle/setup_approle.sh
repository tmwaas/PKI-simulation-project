#!/usr/bin/env bash
set -euo pipefail
: "${VAULT_ADDR:?Set VAULT_ADDR}"
: "${VAULT_TOKEN:?Set VAULT_TOKEN}"
POLICY_NAME="pki-read"
ROLE_NAME="pki-ansible"
POLICY_FILE="$(dirname "$0")/policies/pki-read.hcl"
OUT_DIR="$(dirname "$0")/creds"
mkdir -p "$OUT_DIR"
vault policy write "${POLICY_NAME}" "${POLICY_FILE}"
vault auth enable -path=approle approle 2>/dev/null || true
vault write auth/approle/role/${ROLE_NAME} token_policies="${POLICY_NAME}" token_ttl=1h token_max_ttl=4h secret_id_ttl=4h secret_id_num_uses=10
vault read -format=json auth/approle/role/${ROLE_NAME}/role-id | jq -r .data.role_id > "${OUT_DIR}/role_id"
vault write -format=json -f auth/approle/role/${ROLE_NAME}/secret-id | jq -r .data.secret_id > "${OUT_DIR}/secret_id"
echo "Saved: ${OUT_DIR}/role_id and ${OUT_DIR}/secret_id"
