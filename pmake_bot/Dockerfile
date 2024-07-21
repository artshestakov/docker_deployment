FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

ENV TZ="Europe/Moscow"

RUN \
  apt update && \
  apt upgrade -y && \
  apt -y install libcurl4

WORKDIR /opt/

ENTRYPOINT ["/bin/sh", "-c", "./pmake_bot"]
