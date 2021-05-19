from Pyfhel import Pyfhel

# create an empty Pyfhel object
HE = Pyfhel()

# initialize a context with plaintext modulo 65537
HE.contextGen(p=65537)

# generate a (public/private) key pair
HE.keyGen()

# encrypt two integers
num1 = HE.encryptInt(114)
num2 = HE.encryptInt(514)

# print the last 16 bytes of ciphertexts
print(f"114 is encrypted as ...{num1.to_bytes()[-16:].hex()}")
print(f"514 is encrypted as ...{num2.to_bytes()[-16:].hex()}")

# add
cipher_sum = num1 + num2
plain_sum = HE.decrypt(cipher_sum, decode_value=True)
print(f"Their sum is encrypted as ...{cipher_sum.to_bytes()[-16:].hex()}")
print(f"decrypted sum: {plain_sum}")

# sub
cipher_sub = num2 - num1
plain_sub = HE.decrypt(cipher_sub, decode_value=True)
print(
    f"Their difference is encrypted as ...{cipher_sub.to_bytes()[-16:].hex()}")
print(f"decrypted difference: {plain_sub}")

# mul
cipher_mul = num1 * num2
plain_mul = HE.decrypt(cipher_mul, decode_value=True)
print(f"Their product is encrypted as ...{cipher_mul.to_bytes()[-16:].hex()}")
print(f"decrypted product: {plain_mul}")
