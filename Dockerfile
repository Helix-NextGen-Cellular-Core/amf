# Builds the Helix image ghcr.io/helix-nextgen-cellular-core/amf:v1.0.0
# the same way it was built and verified:
#   docker build -t amf:local .
FROM golang:1.18.3-stretch AS builder
WORKDIR /go/src/amf
COPY . .
RUN go mod vendor \
 && make all && mkdir -p /out/free5gc/amf && cp bin/* /out/free5gc/amf/

FROM alpine:3.24
LABEL org.opencontainers.image.source="https://github.com/Helix-NextGen-Cellular-Core/amf" \
      org.opencontainers.image.licenses="Apache-2.0"
RUN apk update && apk add -U vim strace net-tools curl netcat-openbsd bind-tools bash
COPY --from=builder /out/ /
WORKDIR /free5gc/amf
