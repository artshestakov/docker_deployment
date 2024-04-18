FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

ENV TZ="Europe/Moscow"

RUN \
apt update && \
apt upgrade && \
apt -y install libcurl4

COPY ./yt_dwn_bot /opt/
COPY ./config.ini /opt/
COPY ./run.sh /opt/
COPY ./yt-dlp_linux /opt/

ENTRYPOINT ["/bin/sh", "-c", "/opt/run.sh"]
