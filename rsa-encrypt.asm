section .data
    prompt1 db "Enter first digit (0-9): "
    prompt1_len equ $ - prompt1
    prompt2 db "Enter second digit (0-9): "
    prompt2_len equ $ - prompt2
    output db "Original number: "
    output_len equ $ - output
    encrypted_msg db "Encrypted number: "
    encrypted_len equ $ - encrypted_msg
    decrypted_msg db "Decrypted number: "
    decrypted_len equ $ - decrypted_msg
    error_msg db "Error: Invalid input. Please enter a single digit (0-9)", 10
    error_len equ $ - error_msg
    newline db 10
    params_msg db "RSA Parameters:", 10
    params_len equ $ - params_msg
    p_msg db "  p (first prime) = 7", 10
    p_len equ $ - p_msg
    q_msg db "  q (second prime) = 13", 10
    q_len equ $ - q_msg
    n_msg db "  n (modulus) = 91 (7 × 13)", 10
    n_len equ $ - n_msg
    e_msg db "  e (public exponent) = 5", 10
    e_len equ $ - e_msg
    d_msg db "  d (private exponent) = 29", 10
    d_len equ $ - d_msg
    phi_msg db "  φ(n) = 72 = (7-1) × (13-1)", 10
    phi_len equ $ - phi_msg
    separator db "------------------------", 10
    sep_len equ $ - separator

section .bss
    input_buffer resb 16
    digit1 resb 1
    digit2 resb 1
    number resb 1
    encrypted resb 2
    decrypted resb 1
    num_str resb 3

section .text
    global _main
    default rel

; Constants for RSA
P_PRIME equ 7          ; First prime number
Q_PRIME equ 13         ; Second prime number
N_MODULUS equ 91       ; n = p × q
E_PUBLIC equ 5         ; Public exponent
D_PRIVATE equ 29       ; Private exponent
PHI_N equ 72          ; φ(n) = (p-1) × (q-1)

read_digit:
    ; Input: RSI points to where to store the digit
    push rax
    push rdi
    push rdx

    ; Read input into buffer
    mov rax, 0x2000003
    mov rdi, 0
    mov rdx, 16
    push rsi
    lea rsi, [input_buffer]
    syscall
    pop rsi

    ; Check for read error
    cmp rax, 1
    jl error_exit

    ; Get the first character
    mov al, [input_buffer]
    
    ; Validate it's a digit
    cmp al, '0'
    jl error_exit
    cmp al, '9'
    jg error_exit

    ; Store the digit
    mov [rsi], al

    pop rdx
    pop rdi
    pop rax
    ret

print_number:
    ; Input: AL contains the number to print (0-99)
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rcx
    push rdx

    ; Convert number to ASCII
    xor ah, ah
    mov bl, 10
    div bl          ; Divide by 10
    add ah, '0'     ; Convert remainder to ASCII
    mov [num_str + 1], ah
    add al, '0'     ; Convert quotient to ASCII
    mov [num_str], al
    mov byte [num_str + 2], 0

    ; Print the number
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [num_str]
    mov rdx, 2
    syscall

    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret

rsa_encrypt:
    ; Input: AL contains the number to encrypt (0-99)
    ; Output: AL contains the encrypted number
    ; Using RSA parameters: n = N_MODULUS, e = E_PUBLIC
    push rbx
    push rcx
    push rdx

    ; Perform RSA encryption: c = m^e mod n
    mov bl, al          ; Store original number
    mov al, 1           ; Result
    mov cl, E_PUBLIC    ; e = 5 (exponent)

power_loop:
    mul bl              ; Multiply by original number
    mov dl, N_MODULUS   ; n = 91
    div dl              ; Divide by n
    mov al, ah          ; Keep remainder
    xor ah, ah          ; Clear high byte
    dec cl
    jnz power_loop

    pop rdx
    pop rcx
    pop rbx
    ret

rsa_decrypt:
    ; Input: AL contains the number to decrypt (0-99)
    ; Output: AL contains the decrypted number
    ; Using RSA parameters: n = N_MODULUS, d = D_PRIVATE
    push rbx
    push rcx
    push rdx

    ; Perform RSA decryption: m = c^d mod n
    mov bl, al           ; Store encrypted number
    mov al, 1            ; Result
    mov cl, D_PRIVATE    ; d = 29 (private exponent)

decrypt_loop:
    mul bl               ; Multiply by encrypted number
    mov dl, N_MODULUS    ; n = 91
    div dl               ; Divide by n
    mov al, ah           ; Keep remainder
    xor ah, ah           ; Clear high byte
    dec cl
    jnz decrypt_loop

    pop rdx
    pop rcx
    pop rbx
    ret

_main:
    ; Print RSA parameters
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [params_msg]
    mov rdx, params_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [p_msg]
    mov rdx, p_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [q_msg]
    mov rdx, q_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [n_msg]
    mov rdx, n_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [e_msg]
    mov rdx, e_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [d_msg]
    mov rdx, d_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [phi_msg]
    mov rdx, phi_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [separator]
    mov rdx, sep_len
    syscall

    ; Print first prompt
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [prompt1]
    mov rdx, prompt1_len
    syscall

    ; Get first digit
    lea rsi, [digit1]
    call read_digit

    ; Print second prompt
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [prompt2]
    mov rdx, prompt2_len
    syscall

    ; Get second digit
    lea rsi, [digit2]
    call read_digit

    ; Combine digits into a number
    movzx eax, byte [digit1]
    sub al, '0'
    mov bl, 10
    mul bl
    movzx ebx, byte [digit2]
    sub bl, '0'
    add al, bl
    mov [number], al

    ; Print original number message
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [output]
    mov rdx, output_len
    syscall

    ; Print original number
    mov al, [number]
    call print_number

    ; Print newline
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Encrypt the number
    mov al, [number]
    call rsa_encrypt
    mov [encrypted], al

    ; Print encrypted message
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [encrypted_msg]
    mov rdx, encrypted_len
    syscall

    ; Print encrypted number
    mov al, [encrypted]
    call print_number

    ; Print newline
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Decrypt the number
    mov al, [encrypted]
    call rsa_decrypt
    mov [decrypted], al

    ; Print decrypted message
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [decrypted_msg]
    mov rdx, decrypted_len
    syscall

    ; Print decrypted number
    mov al, [decrypted]
    call print_number

    ; Print newline
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Exit normally
    mov rax, 0x2000001
    xor rdi, rdi
    syscall

error_exit:
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [error_msg]
    mov rdx, error_len
    syscall

    mov rax, 0x2000001
    mov rdi, 1
    syscall