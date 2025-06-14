FROM golang:1.21.7 AS builder
WORKDIR /go/src/github.com/peekwez/rainbow-deploys/
COPY . .
RUN go mod init github.com/peekwez/rainbow-deploys || true
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux make build

FROM scratch
COPY --from=builder /go/src/github.com/peekwez/rainbow-deploys/rainbow-deploys .
ARG COLOR
ENV COLOR=${COLOR}
ENTRYPOINT ["/rainbow-deploys"]