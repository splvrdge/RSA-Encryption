# Use ARM64 base image
FROM --platform=linux/arm64 ubuntu:20.04

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gcc \
    as \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source files
COPY rsa-encrypt-arm64.asm .

# Build the program
RUN as -o rsa-encrypt.o rsa-encrypt-arm64.asm && \
    gcc -o rsa-encrypt rsa-encrypt.o -nostartfiles

# Run the program
CMD ["./rsa-encrypt"]
