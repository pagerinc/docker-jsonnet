FROM alpine:3.10 AS builder

WORKDIR /opt
RUN apk --no-cache add build-base curl unzip

ENV JSONNET_VERSION='0.13.0'

RUN curl -sSL https://github.com/google/jsonnet/archive/v${JSONNET_VERSION}.zip > /opt/jsonnet_v${JSONNET_VERSION}.zip \
	&& unzip jsonnet_v${JSONNET_VERSION}.zip -d /opt/ \
	&& mv jsonnet-${JSONNET_VERSION} jsonnet \
	&& cd jsonnet && make

FROM alpine:3.10

RUN apk add --no-cache libstdc++

COPY --from=builder /opt/jsonnet/jsonnet /usr/local/bin
COPY --from=builder /opt/jsonnet/jsonnetfmt /usr/local/bin

ENTRYPOINT ["/usr/local/bin/jsonnet"]
CMD ["--help"]
