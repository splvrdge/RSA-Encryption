def manual_mod_exp(base, exponent, modulus):
    """Calculate modular exponentiation step by step"""
    print(f"\nCalculating {base}^{exponent} mod {modulus} step by step:")
    result = 1
    for i in range(exponent):
        prev_result = result
        result = (result * base) % modulus
        print(f"Step {i+1}: {prev_result} × {base} = {prev_result * base} mod {modulus} = {result}")
    return result

def python_mod_exp(base, exponent, modulus):
    """Calculate modular exponentiation using Python's pow function"""
    return pow(base, exponent, modulus)

# RSA Parameters
p = 7
q = 13
n = p * q  # modulus
e = 5      # public exponent
d = 29     # private exponent
phi = (p-1) * (q-1)  # Euler's totient

print("RSA Parameters:")
print(f"p (first prime) = {p}")
print(f"q (second prime) = {q}")
print(f"n (modulus) = {n} ({p} × {q})")
print(f"e (public exponent) = {e}")
print(f"d (private exponent) = {d}")
print(f"φ(n) = {phi} = ({p}-1) × ({q}-1)")
print("------------------------")

# Test different messages
test_messages = [11, 53, 21]

for msg in test_messages:
    print(f"\nTesting message: {msg}")
    print("------------------------")
    
    # Manual calculation (with steps)
    encrypted_manual = manual_mod_exp(msg, e, n)
    print(f"\nEncrypted (manual): {encrypted_manual}")
    
    # Python's pow function
    encrypted_python = python_mod_exp(msg, e, n)
    print(f"Encrypted (python): {encrypted_python}")
    
    # Verify they match
    print(f"Manual calculation matches Python: {encrypted_manual == encrypted_python}")
    
    # Decrypt
    decrypted = python_mod_exp(encrypted_python, d, n)
    print(f"Decrypted: {decrypted}")
    print(f"Decryption successful: {decrypted == msg}")
