# RSA Encryption Program in Assembly

> A multi-architecture implementation of RSA encryption in assembly language, supporting x86_64 and ARM64 processors.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Architectures](https://img.shields.io/badge/Architectures-x86__64%20%7C%20ARM64-blue)
![Platform](https://img.shields.io/badge/Platform-Docker-2496ED)

<div align="center">
  <img src="https://www.securew2.com/wp-content/uploads/2024/01/RSA-Encryption-Works.png" alt="RSA Mechanism" width="200"/>
</div>

## Table of Contents
- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Architecture Support](#architecture-support)
- [Running with Docker](#running-with-docker)
- [Program Features](#program-features)
- [How to Use](#how-to-use)
- [Examples](#examples)

## Overview

Submitted by:
| Name | Role |
|------|------|
| Francis James Lagang | Developer |
| Margaret Grace Docdoc | Developer |
| Simone Montañez | Developer |

*Final Project for CS 3103, DCISM, University of San Carlos. December 2024.*

### What is RSA?

RSA is a public-key cryptosystem widely used for secure data transmission. It is based on the practical difficulty of factoring the product of two large prime numbers.

[!NOTE]
This implementation is for educational purposes and demonstrates the basic principles of RSA encryption using small prime numbers.

### Key Components

In this implementation, we use:

| Component | Value | Description |
|-----------|-------|-------------|
| p | 7 | First prime number |
| q | 13 | Second prime number |
| n | 91 | Modulus (p × q) |
| φ(n) | 72 | Euler's totient ((p-1) × (q-1)) |
| e | 5 | Public exponent |
| d | 29 | Private exponent |

### How RSA Works

1. **Key Generation**
   ```mermaid
   graph LR
   A[Choose p,q] --> B[Calculate n = p×q]
   B --> C[Calculate φ(n)]
   C --> D[Choose e]
   D --> E[Calculate d]
   ```

2. **Encryption**
   ```math
   c = m^e \bmod n
   ```
   Where:
   - m is the message
   - c is the ciphertext

3. **Decryption**
   ```math
   m = c^d \bmod n
   ```
   Where:
   - c is the ciphertext
   - m is the original message

## System Requirements

This implementation supports multiple architectures:

- macOS (x86_64)
- Linux (x86_64)
- ARM64 systems (Apple Silicon, etc.)

### Architecture Support

The repository includes three versions:

| File | Architecture | Purpose |
|------|--------------|---------|
| `rsa-encrypt.asm` | x86_64 | macOS native |
| `rsa-encrypt-linux-x86_64.asm` | x86_64 | Linux/Docker |
| `rsa-encrypt-arm64.asm` | ARM64 | Docker ARM |

[!IMPORTANT]
All versions implement identical RSA encryption logic but use architecture-specific assembly instructions and system calls.

## Running with Docker

### For x86_64 Systems
```bash
# Build the image
docker build -f Dockerfile.x86_64 -t rsa-encrypt-x86 .

# Run the container
docker run -it rsa-encrypt-x86
```

### For ARM64 Systems (e.g., Apple Silicon Macs)
```bash
# Build the image
docker build -t rsa-encrypt-arm .

# Run the container
docker run -it rsa-encrypt-arm
```

[!NOTE]
The Docker containers work on any system with Docker installed, regardless of the OS.

## Program Features

- Two-digit number input (0-99)
- RSA parameter display
- Real-time encryption
- Instant decryption
- Input validation

## How to Use

<details>
<summary>Native macOS Build (x86_64)</summary>

```bash
# Assemble
nasm -f macho64 rsa-encrypt.asm

# Link
ld -o rsa-encrypt rsa-encrypt.o -macosx_version_min 10.12 -no_pie -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

# Run
./rsa-encrypt
```
</details>

## Examples

<details>
<summary>Example 1: Regular Case</summary>

```
RSA Parameters:
  p (first prime) = 7
  q (second prime) = 13
  n (modulus) = 91 (7 × 13)
  e (public exponent) = 5
  d (private exponent) = 29
  φ(n) = 72 = (7-1) × (13-1)
------------------------
Enter first digit (0-9): 5
Enter second digit (0-9): 3
Original number: 53
Encrypted number: 79
Decrypted number: 53
```
</details>

<details>
<summary>Example 2: Fixed Point Case</summary>

```
Original number: 21
Encrypted number: 21
Decrypted number: 21
```

[!NOTE]
This is a "fixed point" where the number encrypts to itself.
</details>

## Security Note

[!WARNING]
This is an educational implementation. Production RSA systems use:
- Much larger prime numbers (2048+ bits)
- Proper padding schemes
- Secure random number generation
- Additional security measures

---
<div align="center">
University of San Carlos - Department of Computer and Information Sciences and Mathematics
</div>
