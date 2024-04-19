FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

ENV TZ="Europe/Moscow"

RUN \
apt update && \
apt upgrade && \
apt -y install libcurl4

COPY ./diptok_pochta_bot /opt/
COPY ./run.sh /opt/

ENTRYPOINT ["/bin/sh", "-c", "/opt/run.sh"]
