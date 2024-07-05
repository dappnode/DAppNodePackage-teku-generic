#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet lukso"
CHECKPOINT_SYNC_FLAG="--initial-state"
MEVBOOST_FLAGS="--builder-endpoint"

# shellcheck disable=SC1091 # Path is relative to the Dockerfile
. /etc/profile

handle_checkpoint() {

    teku_checkpoint_url="$(echo "${CHECKPOINT_SYNC_URL}" | sed 's:/*$::')/eth/v2/debug/beacon/states/finalized"

    set_checkpointsync_url "${CHECKPOINT_SYNC_FLAG}" "${teku_checkpoint_url}"
}

run_beacon() {
    echo "[INFO - entrypoint] Starting beacon node"

    # shellcheck disable=SC2086
    exec /opt/teku/bin/teku \
        --network="${NETWORK}" \
        --data-base-path="${DATA_DIR}" \
        --ee-endpoint="${ENGINE_API_URL}" \
        --ee-jwt-secret-file="${JWT_SECRET_FILE}" \
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
        --validators-proposer-default-fee-recipient="${FEE_RECIPIENT}" ${EXTRA_OPTS}
}

format_graffiti
set_beacon_config_by_network "${NETWORK}" "${SUPPORTED_NETWORKS}"
handle_checkpoint
set_mevboost_flag "${MEVBOOST_FLAGS}" # MEVBOOST: https://docs.teku.consensys.net/en/latest/HowTo/Builder-Network/
run_beacon
