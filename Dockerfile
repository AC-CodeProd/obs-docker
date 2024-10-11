FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ARG OBS_VERSION
LABEL maintainer="AC-CodeProd"

ENV TITLE=OBS-Studio

RUN echo "**** install packages ****" && \
apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
  keyboard-configuration tzdata </dev/null \
  build-essential \
  cmake \
  curl \
  ffmpeg \
  git \
  libboost-dev \
  libnss3 \
  mesa-utils \
  qtbase5-dev \
  strace \
  x11-xserver-utils \
  software-properties-common && \
  add-apt-repository ppa:obsproject/obs-studio && \
  if [ -z ${OBS_VERSION+x} ]; then \
    OBS_VERSION=$(curl -sX GET "https://api.github.com/repos/obsproject/obs-studio/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "**** install obs-studio=${OBS_VERSION} from apt-get ****" && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y obs-studio="$(echo ${OBS_VERSION})-*" && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*


COPY /root /

# ports and volumes
EXPOSE 3000 3001
VOLUME /config