section .data
    prompt1 db "Enter first digit (0-9): "
    prompt1_len equ $ - prompt1
    prompt2 db "Enter second digit (0-9): "
    prompt2_len equ $ - prompt2
    output db "You entered: "
    output_len equ $ - output
    error_msg db "Error: Invalid input. Please enter a single digit (0-9)", 10
    error_len equ $ - error_msg
    newline db 10

section .bss
    input_buffer resb 16
    digit1 resb 1
    digit2 resb 1
    temp resb 1

section .text
    global _main
    default rel

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

_main:
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

    ; Print output message
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [output]
    mov rdx, output_len
    syscall

    ; Print first digit
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [digit1]
    mov rdx, 1
    syscall

    ; Print second digit
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [digit2]
    mov rdx, 1
    syscall

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
