FROM golang:1.21-alpine AS builder

RUN apk add --no-cache nodejs npm git

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -buildmode=pie -o drasl

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/drasl .
COPY --from=builder /app/assets ./assets
COPY --from=builder /app/view ./view
COPY --from=builder /app/public ./public
COPY --from=builder /app/locales ./locales

EXPOSE 25585

CMD ["./drasl"]
