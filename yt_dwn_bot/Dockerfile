FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

ENV TZ="Europe/Moscow"

RUN \
  apt update && \
  apt -y upgrade && \
  apt -y install \
    libcurl4 \
    ffmpeg

COPY ./yt_dwn_bot /opt/
COPY ./yt-dlp_linux /opt/
COPY ./run.sh /opt/

ENTRYPOINT ["/bin/sh", "-c", "/opt/run.sh"]
