ARG UPSTREAM_VERSION

FROM consensys/teku:$UPSTREAM_VERSION

ARG NETWORK
ARG P2P_PORT
ARG DATA_DIR
ARG STAKER_SCRIPTS_VERSION

ENV JWT_SECRET_FILE=/jwtsecret \
    P2P_PORT=${P2P_PORT} \
    DATA_DIR=${DATA_DIR} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY jwtsecret.hex ${JWT_SECRET_FILE}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

USER root

RUN apt-get update && apt-get --yes install curl && \
    chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

# This env changes the variant
# Placed at the end to regenerate the least amount of layers
ENV NETWORK=${NETWORK}

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
