ARG UPSTREAM_VERSION

FROM consensys/teku:$UPSTREAM_VERSION

ARG NETWORK
ARG P2P_PORT
ARG STAKER_SCRIPTS_VERSION
ARG JWT_SECRET_FILE=/jwtsecret

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY jwtsecret.hex ${JWT_SECRET_FILE}

ENV JWT_SECRET_FILE=${JWT_SECRET_FILE} \
    NETWORK=${NETWORK} \
    P2P_PORT=${P2P_PORT} \
    DATA_DIR=/opt/teku/data \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

USER root
RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh
USER teku

ENTRYPOINT [ "entrypoint.sh" ]
