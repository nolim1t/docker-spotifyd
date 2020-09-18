# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE

ARG VERSION=v0.2.24
ARG REPO=https://github.com/Spotifyd/spotifyd.git
ARG USER=spotify
ARG UID=1000
ARG GID=1000
ARG DIR=/data/

#FROM rust:1.46.0-slim-buster as builder
FROM rust:1.46.0-slim-buster as final

ARG VERSION
ARG REPO

RUN apt update && apt install -y git build-essential alsa-utils alsa-oss libasound2 libasound2-dev libssl-dev libpulse-dev libdbus-1-dev

WORKDIR /
RUN git clone $REPO
WORKDIR /spotifyd

RUN git checkout $VERSION

RUN cargo build --release

#FROM rust:1.46.0-slim-buster as final

ARG USER
ARG UID
ARG DIR

LABEL maintainer="nolim1t <hello@nolim1t.co>"

RUN adduser --disabled-password \
            --home "$DIR" \
            --uid $UID \
            --gecos "" \
            "$USER"



# For spotifyd config
RUN mkdir -p "$DIR/.config/"

#COPY --from=builder /spotifyd/target/release/spotifyd /usr/local/bin
#COPY --from=builder /usr/* /usr/
#COPY --from=builder /lib/* /lib/

RUN ls -la /spotifyd
RUN ls -la /spotifyd/target/release
RUN ls -la /spotifyd/target/release/deps
RUN ls -la /spotifyd/target/release/spotifyd.d

RUN cp /spotifyd/target/release/spotifyd /usr/local/bin

USER $USER

ENTRYPOINT ["spotifyd"]
