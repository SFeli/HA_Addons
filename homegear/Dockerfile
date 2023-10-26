# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

USER root

# Execute during the build of the image
#ARG TEMPIO_VERSION BUILD_ARCH
#RUN \
#    curl -sSLf -o /usr/bin/tempio \
#    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# Set shell
RUN echo 'Info: Set shell'
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo 'Info: Apt-get update'
RUN apt-get update 
    && apt-get -y install apt-transport-https wget ca-certificates apt-utils gnupg libzip4 libavahi-client3 libavahi-client-dev insserv locales lsb-release

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

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

VOLUME ["/etc/homegear", "/var/lib/homegear", "/var/log/homegear"]


# Copy root filesystem
# COPY rootfs /

COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/bin/bash", "-c", "/run.sh"]

EXPOSE 80 443 2001 2002 2003

