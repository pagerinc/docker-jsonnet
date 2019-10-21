FROM golang:1.13-alpine@sha256:d69f5e3e8f28cbe45f041fb3ee7f77b51420497330bec7c885d25b74f2b519d5 AS builder

WORKDIR /opt

RUN apk --no-cache add build-base curl unzip git bash

ENV JSONNET_VERSION='0.13.0'
ENV JSONNET_BUNDLER_VERION='0.1.0'

RUN curl -sSL https://github.com/google/jsonnet/archive/v${JSONNET_VERSION}.zip > /opt/jsonnet_v${JSONNET_VERSION}.zip \
	&& unzip jsonnet_v${JSONNET_VERSION}.zip -d /opt/ \
	&& mv jsonnet-${JSONNET_VERSION} jsonnet \
	&& cd jsonnet && make

RUN curl -sSL https://github.com/jsonnet-bundler/jsonnet-bundler/archive/v${JSONNET_BUNDLER_VERION}.zip > /opt/jsonnet-bundler_v${JSONNET_BUNDLER_VERION}.zip \
	&& unzip jsonnet-bundler_v${JSONNET_BUNDLER_VERION}.zip -d /opt/ \
	&& mv jsonnet-bundler-${JSONNET_BUNDLER_VERION} jsonnet-bundler \
	&& cd jsonnet-bundler && make && make install

FROM alpine:3.10@sha256:e4355b66995c96b4b468159fc5c7e3540fcef961189ca13fee877798649f531a

RUN apk add --no-cache libstdc++

COPY --from=builder /opt/jsonnet/jsonnet /usr/local/bin
COPY --from=builder /opt/jsonnet/jsonnetfmt /usr/local/bin
COPY --from=builder /go/bin/jb /usr/local/bin/
COPY ./entrypoint.sh /

RUN chmod a+x /usr/local/bin/jb /usr/local/bin/jsonnet /usr/local/bin/jsonnetfmt /entrypoint.sh

WORKDIR /src
VOLUME /src
ENV BASEDIR=/src

ENTRYPOINT ["/entrypoint.sh"]
