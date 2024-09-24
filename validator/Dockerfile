ARG UPSTREAM_VERSION

FROM consensys/teku:${UPSTREAM_VERSION}

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION

USER root 

ENV TLS_CERT_PATH=/tls/cert

ENV DATA_DIR=/opt/teku/data \
    NETWORK=${NETWORK} \
    VALIDATOR_PORT=3500 \
    VALIDATOR_API_TOKEN_PATH=/opt/teku/data/validator/key-manager/validator-api-bearer \
    TLS_CERT_FILE_PATH=${TLS_CERT_PATH}/teku_client_keystore.p12 \
    TLS_CERT_PASS_PATH=${TLS_CERT_PATH}/teku_keystore_password.txt \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

COPY /security/validator-api-bearer ${VALIDATOR_API_TOKEN_PATH}
COPY /security/cert ${TLS_CERT_PATH}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN apt-get update && apt-get install ca-certificates --yes --no-install-recommends && apt-get clean && \
    chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

# This env changes the variant
# Placed at the end to regenerate the least amount of layers
ENV NETWORK=${NETWORK}

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
