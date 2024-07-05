#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet lukso"
MEVBOOST_FLAG_1="--validators-builder-registration-default-enabled=true"
MEVBOOST_FLAG_2="--validators-proposer-blinded-blocks-enabled=true"
SKIP_MEVBOOST_URL="true"
CLIENT="teku"
VALIDATOR_PORT=3500

# shellcheck disable=SC1091
. /etc/profile

run_validator() {

  echo "[INFO - entrypoint] Starting validator client"

  # Teku must start with the current env due to JAVA_HOME var
  # shellcheck disable=SC2086
  exec /opt/teku/bin/teku \
    --log-destination=CONSOLE \
    validator-client \
    --network="${NETWORK}" \
    --data-base-path="${DATA_DIR}" \
    --beacon-node-api-endpoint="${BEACON_API_URL}" \
    --validators-external-signer-url="${WEB3SIGNER_API_URL}" \
    --metrics-enabled=true \
    --metrics-interface 0.0.0.0 \
    --metrics-port 8008 \
    --metrics-host-allowlist=* \
    --validator-api-enabled=true \
    --validator-api-interface=0.0.0.0 \
    --validator-api-port="${VALIDATOR_PORT}" \
    --validator-api-host-allowlist=* \
    --validators-graffiti="${GRAFFITI}" \
    --validator-api-keystore-file="${TLS_CERT_FILE_PATH}" \
    --validator-api-keystore-password-file="${TLS_CERT_PASS_PATH}" \
    --validators-proposer-default-fee-recipient="${FEE_RECIPIENT}" \
    --logging="${LOG_LEVEL}" ${EXTRA_OPTS}
}

format_graffiti
set_validator_config_by_network "${NETWORK}" "${SUPPORTED_NETWORKS}" "${CLIENT}"
# MEVBOOST: https://docs.teku.consensys.net/en/latest/HowTo/Builder-Network/
set_mevboost_flag "${MEVBOOST_FLAG_1}" "${SKIP_MEVBOOST_URL}"
set_mevboost_flag "${MEVBOOST_FLAG_2}" "${SKIP_MEVBOOST_URL}"
run_validator
