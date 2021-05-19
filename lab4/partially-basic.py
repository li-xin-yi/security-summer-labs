from phe import paillier

# generate a key pair

public_key, private_key = paillier.generate_paillier_keypair()

# encrypt 114 and 514
num1, num2 = public_key.encrypt(114), public_key.encrypt(514)
print(f"114 is encrypted as {num1.ciphertext(be_secure=False):x}")
print(f"514 is encrypted as {num2.ciphertext(be_secure=False):x}")

# add
cipher_sum = num1 + num2
plain_sum = private_key.decrypt(cipher_sum)
print(f"Their sum is encrypted as {cipher_sum.ciphertext(be_secure=False):x}")
print(f"decrypted sum: {plain_sum}")

# sub
cipher_sub = num2 - num1
plain_sub = private_key.decrypt(cipher_sub)
print(f"Their difference is encrypted as {cipher_sub.ciphertext(be_secure=False):x}")
print(f"decrypted difference: {plain_sub}")

# mul
cipher_product = num1 * 3
plain_product = private_key.decrypt(cipher_product)
print(f"Their product is encrypted as {cipher_product.ciphertext(be_secure=False):x}")
print(f"decrypted product: {plain_product}")
