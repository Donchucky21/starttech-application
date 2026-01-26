# ---- build stage ----
FROM golang:1.25-alpine AS builder

WORKDIR /app

# dependencies first (better caching)
COPY go.mod go.sum ./
RUN go mod download

# copy source
COPY . .

# build binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api ./cmd/api

# ---- runtime stage ----
FROM alpine:3.20

# add certs for https calls (Mongo Atlas, etc.)
RUN apk add --no-cache ca-certificates wget tzdata

WORKDIR /app

# non-root user
RUN adduser -D -g '' appuser
USER appuser

COPY --from=builder /app/api /app/api

# app listens on 8080 (adjust if your app uses something else)
EXPOSE 8080

# if your app supports /health, great. otherwise we’ll add it.
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/health || exit 1

CMD ["/app/api"]
