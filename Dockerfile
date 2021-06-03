# hadolint ignore=DL3029
FROM --platform=${BUILDPLATFORM} golang:alpine AS builder

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 \
	GOOS=${TARGETOS} \
	GOARCH=${TARGETARCH} \
	go install -ldflags '-s -w -extldflags "-static"' github.com/googleapis/api-linter/cmd/api-linter@v1.25.0

RUN find bin -name 'api-linter' -executable -exec cp -- "{}" /go/bin \;

FROM alpine:3

LABEL org.opencontainers.image.source=https://github.com/docker-multiarch/google-api-linter \
	org.opencontainers.image.version=v1.25.0

COPY --from=builder /go/bin/api-linter /usr/local/bin

USER 10001

ENTRYPOINT ["api-linter"]
