# Etapa 1: Compilación del binario
FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o appwatch main.go

# Etapa 2: Construcción de la imagen final
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/appwatch .

EXPOSE 8080
CMD ["./appwatch"]