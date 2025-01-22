FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

RUN \
  apt update && \
  apt -y upgrade && \
  apt -y install \
    libcurl4 \
    ffmpeg \
    procps \
    binutils

WORKDIR /opt/
