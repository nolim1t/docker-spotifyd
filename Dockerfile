ARG VERSION=v0.2.24
ARG REPO=https://github.com/Spotifyd/spotifyd.git
ARG USER=spotify
ARG UID=1000
ARG GID=1000
ARG DIR=/data/

FROM rust:1.46.0-slim-buster as builder

ARG VERSION
ARG REPO

RUN apt update && apt install -y git build-essential alsa-utils alsa-oss libasound2 libasound2-dev libssl-dev libpulse-dev libdbus-1-dev
WORKDIR /
RUN git clone $REPO
WORKDIR /spotifyd

RUN git checkout $VERSION

RUN cargo build --release

FROM rust:1.46.0-slim-buster as final

ARG USER
ARG UID
ARG DIR

LABEL maintainer="nolim1t <hello@nolim1t.co>"

RUN adduser --disabled-password \
            --home "$DIR" \
            --uid $UID \
            --gecos "" \
            "$USER"



USER $USER

# For spotifyd config
RUN mkdir -p "$DIR/.config/"

COPY --from=builder /spotifyd/target/release/spotifyd /usr/local/bin
COPY --from=builder /usr/lib /usr/lib


ENTRYPOINT ["spotifyd"]
