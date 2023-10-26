# Debian bookworm --> 12.2
# Debian bullseye --> 11.8 
ARG BUILD_FROM=debian:11.8-slim
FROM $BUILD_FROM

USER root

ENV \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    CURL_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_SERVICES_READYTIME=50

# Set shell
#RUN \
#   echo 'Info: Set shell'
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build Args
ARG BUILD_ARCH=amd64
ARG BUILD_REF=homegear
ARG BUILD_VERSION=test
ARG BASHIO_VERSION="v0.16.0"
ARG TEMPIO_VERSION="2021.09.0"
ARG S6_OVERLAY_VERSION="3.1.5.0"

# Labels
LABEL \
    io.hass.name="Homegear" \
    io.hass.description="Homegear." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="SFELI>" \
    org.label-schema.description="Homegear." \
    org.label-schema.build-date=${BUILD_DATE} \


# RUN echo 'Info: Apt-get update'
RUN \
    apt-get update \
    && apt-get -y install --no-install-recommends apt-transport-https wget ca-certificates \
    apt-utils gnupg libzip4 libavahi-client3 \
    libavahi-client-dev insserv locales lsb-release

RUN \
    S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="i686"; \
    elif [ "${BUILD_ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; \
    elif [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" \
        | tar -C / -Jxpf - \
    && mkdir -p /etc/fix-attrs.d \
    && mkdir -p /etc/services.d \
    && curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && curl -L -s -o /usr/bin/tempio \
        "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/tempio \
    && apt-get purge -y --auto-remove \
        xz-utils \
    && apt-get clean \
    && rm -fr \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

RUN echo 'Info: Touch'
RUN \
    touch /tmp/HOMEGEAR_STATIC_INSTALLATION; \
    touch /.dockerenv; \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; \
    locale-gen; \
    wget https://apt.homegear.eu/Release.key && apt-key add Release.key && rm Release.key; \
    echo 'deb https://apt.homegear.eu/debian/bullseye/homegear/testing/ bullseye main' >> /etc/apt/sources.list.d/homegear.list; \
    apt-get update && apt-get -y install libhomegear-node homegear homegear-management homegear-webssh homegear-adminui homegear-ui homegear-nodes-core homegear-nodes-extra homegear-homematicbidcos homegear-homematicwired homegear-max homegear-zigbee homegear-ccu homegear-influxdb; \
    rm -f /etc/homegear/dh1024.pem; \
    rm -f /etc/homegear/homegear.crt; \
    rm -f /etc/homegear/homegear.key; \
    cp -a /etc/homegear /etc/homegear.config; \
    cp -a /var/lib/homegear /var/lib/homegear.data; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/etc/homegear", "/var/lib/homegear", "/var/log/homegear"]

# Copy root filesystem
# COPY rootfs /

COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/bin/bash", "-c", "/run.sh"]

EXPOSE 80 443 2001 2002 2003

