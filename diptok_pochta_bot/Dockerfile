FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

RUN \
  apt update && \
  apt upgrade -y && \
  apt -y install \
    libcurl4 \
    binutils

WORKDIR /opt/
