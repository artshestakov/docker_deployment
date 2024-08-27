FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y curl && \
  apt-get install -y git cmake build-essential libssl-dev && \
  apt-get install -y icu-devtools libicu-dev libicu-le-hb-dev libicu-le-hb0 libicu67

RUN \
  mkdir /opt/runner && \
  curl -o /opt/runner/actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz && \
  tar xzf /opt/runner/actions-runner-linux-x64-2.319.1.tar.gz -C /opt/runner

RUN \
  cd /opt/runner && \
  RUNNER_ALLOW_RUNASROOT="1" ./config.sh --unattended --url https://github.com/artshestakov/Migrator --token ALYBK6D5CAGAG7UVNAFVYCTGZXU44 --name debian_runner --replace true

WORKDIR /opt/runner
