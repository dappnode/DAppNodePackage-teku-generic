#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet lukso"
# MEVBOOST: https://docs.teku.consensys.net/en/latest/HowTo/Builder-Network/
MEVBOOST_FLAG_KEYS="--validators-builder-registration-default-enabled=true --validators-proposer-blinded-blocks-enabled=true"
SKIP_MEVBOOST_URL="true"
CLIENT="teku"

# shellcheck disable=SC1091
. /etc/profile

VALID_GRAFFITI=$(get_valid_graffiti "${GRAFFITI}")
VALID_FEE_RECIPIENT=$(get_valid_fee_recipient "${FEE_RECIPIENT}")
SIGNER_API_URL=$(get_signer_api_url "${NETWORK}" "${SUPPORTED_NETWORKS}")
BEACON_API_URL=$(get_beacon_api_url "${NETWORK}" "${SUPPORTED_NETWORKS}" "${CLIENT}")
MEVBOOST_FLAGS=$(get_mevboost_flag "${MEVBOOST_FLAG_KEYS}" "${SKIP_MEVBOOST_URL}")

FLAGS="--log-destination=CONSOLE \
  validator-client \
  --network=$NETWORK \
  --data-base-path=$DATA_DIR \
  --beacon-node-api-endpoint=$BEACON_API_URL \
  --validators-external-signer-url=$SIGNER_API_URL \
  --metrics-enabled=true \
  --metrics-interface=0.0.0.0 \
  --metrics-port=8008 \
  --metrics-host-allowlist=* \
  --validator-api-enabled=true \
  --validator-api-interface=0.0.0.0 \
  --validator-api-port=$VALIDATOR_PORT \
  --validator-api-host-allowlist=* \
  --validators-graffiti=$VALID_GRAFFITI \
  --validator-api-keystore-file=$TLS_CERT_FILE_PATH \
  --validator-api-keystore-password-file=$TLS_CERT_PASS_PATH \
  --validators-proposer-default-fee-recipient=$VALID_FEE_RECIPIENT \
  --logging=$LOG_LEVEL $MEVBOOST_FLAGS $EXTRA_OPTS"

echo "[INFO - entrypoint] Starting validator with flags: $FLAGS"

# Teku must start with the current env due to JAVA_HOME var
# shellcheck disable=SC2086
exec /opt/teku/bin/teku $FLAGS
