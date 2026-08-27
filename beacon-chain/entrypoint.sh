#!/bin/sh

CHECKPOINT_SYNC_KEY="--checkpoint-sync-url"
MEVBOOST_FLAG_KEYS="--builder-endpoint"

# https://github.com/lukso-network/network-configs/blob/main/mainnet/teku/teku.yaml
LUKSO_BOOTNODES="enr:-MK4QHcS3JeTtVjOuJyVXvO1E6XJWqiwmhLfodel6vARPI8ve_2q9vVn8LpIL964qBId7zGpSVKw6oOPAaRm2H7ywYiGAYmHDeBbh2F0dG5ldHOIAAAAAAAAAACEZXRoMpA2ulfbQgAABP__________gmlkgnY0gmlwhCIgwNOJc2VjcDI1NmsxoQNGVC8JPcsqsZPoohLP1ujAYpBfS0dBwiz4LeoUQ-k5OohzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A,enr:-Ly4QF7f-m7CiC1EwxmEa3VosxSUAeBaegcOek-J2DgqkB9EHyo5UOCZKAKuGN3pt3S28HVZy1PS6CGILRa8h25pZCsFh2F0dG5ldHOI__________-EZXRoMpCq3eQ4QgAABv__________gmlkgnY0gmlwhLJobp6Jc2VjcDI1NmsxoQJ88Tw_HsGhSdHp8AflKAJnt7VyHNDakc57AT6jdaBihIhzeW5jbmV0cw-DdGNwgiMog3VkcIIjKA,enr:-Jq4QABOsAAluqXVlLuAAWcMtYF__YTHcAWCChtvzXYa2GMuB5bEFaRnsoCuXUHTx4hxABFwwG29eQd3vH4GCZQbgdEBhGV0aDKQ3FGxEUIAAASkHwAAAAAAAIJpZIJ2NIJpcIQ5gLgeiXNlY3AyNTZrMaECWsDTDT1LTmpENdKPc6IbbViy5D1mahB4AJnPOCafYjKDdWRwgiMy"

# shellcheck disable=SC1091 # Path is relative to the Dockerfile
. /etc/profile

ENGINE_URL="http://execution.${NETWORK}.staker.dappnode:8551"
VALID_FEE_RECIPIENT=$(get_valid_fee_recipient "${FEE_RECIPIENT_ADDRESS}")
MEVBOOST_FLAG=$(get_mevboost_flag "${NETWORK}" "${MEVBOOST_FLAG_KEYS}")

if [ "${NETWORK}" = "lukso" ]; then
    LUKSO_BOOTNODES_FLAG="--p2p-discovery-bootnodes=$LUKSO_BOOTNODES"
fi

if [ -n "${CHECKPOINT_SYNC_URL}" ]; then
    TEKU_FORMAT_CHECKPOINT_URL="$(echo "${CHECKPOINT_SYNC_URL}" | sed 's:/*$::')"
    CHECKPOINT_SYNC_FLAG=$(get_checkpoint_sync_flag "${CHECKPOINT_SYNC_KEY}" "${TEKU_FORMAT_CHECKPOINT_URL}")
fi

JWT_SECRET=$(get_jwt_secret_by_network "${NETWORK}")
echo "${JWT_SECRET}" >"${JWT_FILE_PATH}"

FLAGS="--network=$NETWORK \
    --data-base-path=$DATA_DIR \
    --ee-endpoint=$ENGINE_URL \
    --ee-jwt-secret-file=$JWT_FILE_PATH \
    --p2p-port=$P2P_PORT \
    --beacon-liveness-tracking-enabled=true \
    --rest-api-cors-origins=* \
    --rest-api-interface=0.0.0.0 \
    --rest-api-port=3500 \
    --rest-api-host-allowlist=* \
    --rest-api-enabled=true \
    --rest-api-docs-enabled=true \
    --metrics-enabled=true \
    --metrics-interface=0.0.0.0 \
    --metrics-port=8008 \
    --metrics-host-allowlist=* \
    --log-destination=CONSOLE \
    --validators-proposer-default-fee-recipient=$VALID_FEE_RECIPIENT $LUKSO_BOOTNODES_FLAG $CHECKPOINT_SYNC_FLAG $MEVBOOST_FLAG $EXTRA_OPTS"

echo "[INFO - entrypoint] Starting beacon with flags: $FLAGS"

# shellcheck disable=SC2086
exec /opt/teku/bin/teku $FLAGS
