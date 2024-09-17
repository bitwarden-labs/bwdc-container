FROM ubuntu:22.04@sha256:c985bc3f77946b8e92c9a3648c6f31751a7dd972e06604785e47303f4ad47c4c

ARG DEBIAN_FRONTEND="noninteractive"

RUN echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    dbus-x11 \
    gnome-keyring \
    jq \
    libsecret-1-0 \
    unzip \
    openssl && \
  echo "**** install bwdc ****" && \
  if [ -z ${BWDC_RELEASE+x} ]; then \
    BWDC_RELEASE=$(curl -sX GET "https://api.github.com/repos/bitwarden/directory-connector/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  curl -o \
    /tmp/bwdc.zip -L \
    "https://github.com/bitwarden/directory-connector/releases/download/${BWDC_RELEASE}/bwdc-linux-${BWDC_RELEASE#v}.zip" && \
  unzip -o /tmp/bwdc.zip -d /usr/local/bin/ && \
  chmod 644 /usr/local/bin/bwdc /usr/local/bin/keytar.node && \
  chmod +x /usr/local/bin/bwdc && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /var/log/*

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set the entrypoint script as the entry point
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set CMD to run the bwdc command (or replace with your main command)
CMD ["bwdc"]
