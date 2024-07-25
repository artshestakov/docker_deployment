FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

ENV TZ="Europe/Moscow"

RUN \
  apt update && \
  apt -y upgrade && \
  apt -y install \
    libcurl4 \
    ffmpeg

WORKDIR /opt/
