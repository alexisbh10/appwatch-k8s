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

# Buenas prácticas de seguridad: ejecutar como usuario no root
RUN addgroup -S appwatch && adduser -S appwatch -G appwatch

USER appwatch

CMD ["./appwatch"]