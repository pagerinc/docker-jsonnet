FROM golang:1.13-alpine@sha256:4d6f82fc04c3ef4616c93721e64b709e6bc7fb39ec708fd9cc2ddd874d21a1c3 AS builder

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

FROM alpine:3.11@sha256:ddba4d27a7ffc3f86dd6c2f92041af252a1f23a8e742c90e6e1297bfa1bc0c45

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
