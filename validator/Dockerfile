ARG UPSTREAM_VERSION

FROM consensys/teku:${UPSTREAM_VERSION}

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION
ARG VALIDATOR_API_TOKEN_PATH=/opt/teku/data/validator/key-manager/validator-api-bearer
ARG TLS_CERT_PATH=/tls/cert

USER root 

COPY /security/validator-api-bearer ${VALIDATOR_API_TOKEN_PATH}
COPY /security/cert ${TLS_CERT_PATH}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV DATA_DIR=/opt/teku/data \
    NETWORK=${NETWORK} \
    TLS_CERT_FILE_PATH=${TLS_CERT_PATH}/teku_client_keystore.p12 \
    TLS_CERTS_PASS_PATH=${TLS_CERT_PATH}/teku_keystore_password.txt \
    VALIDATOR_API_TOKEN_PATH=${VALIDATOR_API_TOKEN_PATH} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

RUN apt-get update && apt-get install ca-certificates --yes --no-install-recommends && apt-get clean 

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
