# Use an x86_64 base image
FROM amd64/ubuntu:20.04

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nasm \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source files
COPY rsa-encrypt-linux.asm .

# Build the program
RUN nasm -f elf64 rsa-encrypt-linux.asm && \
    ld -o rsa-encrypt rsa-encrypt-linux.o

# Run the program
CMD ["./rsa-encrypt"]
