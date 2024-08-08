#!/bin/sh

CHECKPOINT_SYNC_FLAG="--initial-state"
MEVBOOST_FLAG_KEYS="--builder-endpoint"
TEKU_FORMAT_CHECKPOINT_URL="$(echo "${CHECKPOINT_SYNC_URL}" | sed 's:/*$::')/eth/v2/debug/beacon/states/finalized"

# shellcheck disable=SC1091 # Path is relative to the Dockerfile
. /etc/profile

ENGINE_URL="http://execution.${NETWORK}.staker.dappnode:8551"
VALID_FEE_RECIPIENT=$(get_valid_fee_recipient "${FEE_RECIPIENT}")
CHECKPOINT_SYNC_FLAG=$(get_checkpoint_sync_flag "${CHECKPOINT_SYNC_FLAG}" "${TEKU_FORMAT_CHECKPOINT_URL}")
MEVBOOST_FLAG=$(get_mevboost_flag "${NETWORK}" "${MEVBOOST_FLAG_KEYS}")

JWT_SECRET=$(get_jwt_secret_by_network "${NETWORK}")
echo "${JWT_SECRET}" >"${JWT_FILE_PATH}"

echo "[INFO - entrypoint] Starting beacon node"

# shellcheck disable=SC2086
exec /opt/teku/bin/teku \
    --network="${NETWORK}" \
    --data-base-path="${DATA_DIR}" \
    --ee-endpoint="${ENGINE_URL}" \
    --ee-jwt-secret-file="${JWT_FILE_PATH}" \
    --p2p-port="${P2P_PORT}" \
    --rest-api-cors-origins="*" \
    --rest-api-interface=0.0.0.0 \
    --rest-api-port=3500 \
    --rest-api-host-allowlist "*" \
    --rest-api-enabled=true \
    --rest-api-docs-enabled=true \
    --metrics-enabled=true \
    --metrics-interface 0.0.0.0 \
    --metrics-port 8008 \
    --metrics-host-allowlist "*" \
    --log-destination=CONSOLE \
    --validators-proposer-default-fee-recipient="${VALID_FEE_RECIPIENT}" ${CHECKPOINT_SYNC_FLAG} ${MEVBOOST_FLAG} ${EXTRA_OPTS}
