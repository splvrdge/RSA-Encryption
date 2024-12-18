.data
    // RSA Parameters messages
    params_msg:     .string "RSA Parameters:\n"
    p_msg:         .string "  p (first prime) = 7\n"
    q_msg:         .string "  q (second prime) = 13\n"
    n_msg:         .string "  n (modulus) = 91 (7 × 13)\n"
    e_msg:         .string "  e (public exponent) = 5\n"
    d_msg:         .string "  d (private exponent) = 29\n"
    phi_msg:       .string "  φ(n) = 72 = (7-1) × (13-1)\n"
    separator:     .string "------------------------\n"
    prompt1:       .string "Enter first digit (0-9): "
    prompt2:       .string "Enter second digit (0-9): "
    output:        .string "Original number: "
    encrypted_msg: .string "Encrypted number: "
    decrypted_msg: .string "Decrypted number: "
    error_msg:     .string "Error: Invalid input. Please enter a single digit (0-9)\n"
    newline:       .string "\n"

    // Constants for RSA
    .equ P_PRIME,    7          // First prime number
    .equ Q_PRIME,    13         // Second prime number
    .equ N_MODULUS,  91         // n = p × q
    .equ E_PUBLIC,   5          // Public exponent
    .equ D_PRIVATE,  29         // Private exponent
    .equ PHI_N,      72         // φ(n) = (p-1) × (q-1)

.bss
    .align 4
    input_buffer:   .skip 16
    digit1:         .skip 1
    digit2:         .skip 1
    number:         .skip 1
    encrypted:      .skip 2
    decrypted:      .skip 1
    num_str:        .skip 3

.text
    .align 2
    .global _start
    .type _start, %function

// Function to print a string
print_string:
    // x0 = file descriptor (1 for stdout)
    // x1 = pointer to string
    // x2 = length of string
    mov x8, #64         // sys_write
    svc #0
    ret

// Function to read input
read_input:
    // x0 = file descriptor (0 for stdin)
    // x1 = buffer address
    // x2 = buffer size
    mov x8, #63         // sys_read
    svc #0
    ret

// RSA encryption function
rsa_encrypt:
    // w0 contains the number to encrypt
    push {x29, x30}
    mov x29, sp
    
    mov w2, w0          // Store original number
    mov w0, #1          // Result
    mov w3, #E_PUBLIC   // Public exponent

1:  // Power loop
    mul w0, w0, w2      // Multiply by original number
    udiv w4, w0, #N_MODULUS
    msub w0, w4, w1, w0 // w0 = w0 - (w4 * w1) (modulo operation)
    subs w3, w3, #1
    bne 1b
    
    pop {x29, x30}
    ret

// RSA decryption function
rsa_decrypt:
    // w0 contains the number to decrypt
    push {x29, x30}
    mov x29, sp
    
    mov w2, w0          // Store encrypted number
    mov w0, #1          // Result
    mov w3, #D_PRIVATE  // Private exponent

1:  // Decrypt loop
    mul w0, w0, w2      // Multiply by encrypted number
    udiv w4, w0, #N_MODULUS
    msub w0, w4, w1, w0 // Modulo operation
    subs w3, w3, #1
    bne 1b
    
    pop {x29, x30}
    ret

_start:
    // Print RSA parameters
    mov x0, #1
    adr x1, params_msg
    mov x2, #16
    bl print_string

    // Print prime p
    mov x0, #1
    adr x1, p_msg
    mov x2, #23
    bl print_string

    // Print prime q
    mov x0, #1
    adr x1, q_msg
    mov x2, #25
    bl print_string

    // Get first digit
    mov x0, #1
    adr x1, prompt1
    mov x2, #24
    bl print_string

    mov x0, #0
    adr x1, input_buffer
    mov x2, #2
    bl read_input

    // Validate and convert input
    ldrb w0, [x1]
    sub w0, w0, #'0'
    cmp w0, #9
    bhi error

    // Store first digit
    strb w0, [x1]

    // Get second digit
    mov x0, #1
    adr x1, prompt2
    mov x2, #25
    bl print_string

    mov x0, #0
    adr x1, input_buffer
    mov x2, #2
    bl read_input

    // Validate and convert second digit
    ldrb w0, [x1]
    sub w0, w0, #'0'
    cmp w0, #9
    bhi error

    // Combine digits and encrypt
    lsl w1, w0, #1
    add w0, w1, w0, lsl #3   // w0 = w0 * 10
    add w0, w0, w1           // Add first digit

    // Print original number
    mov x0, #1
    adr x1, output
    mov x2, #16
    bl print_string

    // Encrypt
    bl rsa_encrypt
    
    // Print encrypted number
    mov x0, #1
    adr x1, encrypted_msg
    mov x2, #17
    bl print_string

    // Decrypt
    bl rsa_decrypt
    
    // Print decrypted number
    mov x0, #1
    adr x1, decrypted_msg
    mov x2, #17
    bl print_string

    // Exit
    mov x0, #0
    mov x8, #93         // sys_exit
    svc #0

error:
    mov x0, #1
    adr x1, error_msg
    mov x2, #48
    bl print_string
    mov x0, #1
    mov x8, #93         // sys_exit
    svc #0
