FROM debian:bullseye-slim
MAINTAINER Shestakov Artem

# Устанавливаем базовые пакеты
RUN \
  apt update && \
  apt -y upgrade && \
  apt -y install \
    libcurl4 \
    ffmpeg \
    procps \
    binutils \
    curl \
    gpg

# Устанавливаем репозиторий с PostgreSQL
RUN \
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list

# Устанавливаем libpq
RUN \
  apt update && \
  apt -y upgrade && \
  apt -y install \
    libpq5 \
    libpq5-dbgsym

WORKDIR /opt/
