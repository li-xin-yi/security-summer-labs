# Lab 4: Processing encrypted data with Homomorphic Encryption (HE)

**(Fully) Homomorphic Encryption (HE)** is a special class of encryption technique that allows for computations to be done on encrypted data, without requiring key to decrypt the ciphertext before operations and keep encrypted. It was first envisioned in 1978 [^rivest1978data] and constructed in 2009 [^gentry2009fully]. By applying HE to protect the customer's data on cloud, the cloud service can perform the computation directly on the given data with a state-of-the-art cryptographic security guarantee.

```{seealso}
In general, a *fully* homomorphic encryption system supports both addition and multiplication operartions, while a *partially* homomorphic encryption may only enable one of them (e.g. [Paillier cryptosystem](https://en.wikipedia.org/wiki/Paillier_cryptosystem) is one implementation of partially homomorphic encryption that supports only addition operation [^paillier1999public]).
```

[^paillier1999public]: Paillier, Pascal. "[Public-key cryptosystems based on composite degree residuosity classes](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.2.8294&rep=rep1&type=pdf)." In *International conference on the theory and applications of cryptographic techniques*, pp. 223-238. Springer, Berlin, Heidelberg, 1999.

[^rivest1978data]: Rivest, Ronald L., Len Adleman, and Michael L. Dertouzos. "[On data banks and privacy homomorphisms](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.500.3989&rep=rep1&type=pdf)." *Foundations of secure computation* 4, no. 11 (1978): 169-180.

[^gentry2009fully]: Gentry, Craig. "[Fully homomorphic encryption using ideal lattices](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.362.7592&rep=rep1&type=pdf)." In *Proceedings of the forty-first annual ACM symposium on Theory of computing*, pp. 169-178. 2009.

## Set-up

Install Python and `pip`

```
$ sudo apt install python3-dev
```

````{tabbed} Python
Create a virtual Python environment named `he-lab`

```
$ pip install virtualenv
$ virtualenv he-lab
$ source ~/he-lab/bin/activate
```

Install [python-paillier](https://github.com/data61/python-paillier):

```
$ pip install phe
```

Install [Pyfhel](https://github.com/ibarrond/Pyfhel)

```
$ pip install Pyfhel
```

````

````{tabbed} CLI
Install [python-paillier](https://github.com/data61/python-paillier):

```
$ pip install phe[cli]
```

Check:

```
$ pheutil --version
```

````

## Basic Property

### Partially HE

`````{tabbed} Python

Source code: {download}`partially-basic.py`

<!-- ```{literalinclude} partially-basic.py
:language: python
:linenos:
``` -->

Generate a public/private key pair by `python-paillier` library

```py
>>> from phe import paillier
>>> public_key, private_key = paillier.generate_paillier_keypair()
```

Encrypt two integers: 114 and 514

```py
>>> num1, num2 = public_key.encrypt(114), public_key.encrypt(514)
>>> print(f"114 is encrypted as {num1.ciphertext(be_secure=False):x}")
>>> print(f"514 is encrypted as {num2.ciphertext(be_secure=False):x}")
114 is encrypted as 333e623d08badb0908b23d71fe9cdc67f2b8d0d2409d0bf77c43d658f69d80d230612c56abe72d9d0a4f3cc4e4e1f4baf86b3603b83d9c500383ac56cf029684198e1f32b222068cbc4ef3fe2ec774f18d9f5f09b7a803a4e232ce69fb2519ab41c0468e2a39c6040291bad0ed8abb8e91fac521ef643cbed7bc5222d5366fb2bfded1b82f23ba396ae5958da28692c27167551cefce08e587248d2e0bb4ffb01cf0ab777ee8b4166f21e808f136c7a49b804434a2819adbceba4a23d8db65252175265f7a5feaf9b23c8fda800bb77e4e6e73e9a932f47da04cc9924618f655489b2b09485c2323306933f686c7a592a91c329e0cab162fac7ce5859149b023226ee603ac46c3d02e84720dfe48a3ed58e2a1fe9e994fca95a618330c5cd5f8327242eb6c9622f13fea77ba596743b1c337bce9a4bc64e712aa698410aaf995fc7a7cce7e122ffbb61876e9017ab67a8ea65cceff97cf768a263390579cc2fafd85c5498184419f5ce45cc8d6ec08200b95409a3b6322629bda594ce87b3ea7872ccb58e6d63c739dcb489ed59aa580e12ec850166d9452630f80a9e7997fd7ea346732a803d809d6e70a2e5c086f02cb885b2b72b38850ce09d00e20db17670a0512764635347e21a0baff709eacbb15995547ae38589312c7ae1baacc25f57615aebf8980d3b952539951c79535e36f448604568cee17cb075ddec4cf26a4
514 is encrypted as 6aad1b534289ace0d6cd3edd22500a1d123ed5b5989d56b83369c407b1b2347db7bbe2cac37c322af2284ba40dacbe913d135754981ccab6ebd13ce319687a1cabba7050f7da2fe366e02d21b1b383522a46bec29c0f6c4a03358f59e233252c4e2eada93932104a20565482ddb402b05bcb8ba33c0eda67fd138b27964db89f4ab370645165d77f741f5bd12ff97f6b9019f13bbeeb90b5efb2613919d361a91278b91d5dd9bff0bb64b7d71d6e964a9ad16c38ca9e4d5a0a6a6061d664758d11d8efeecac4bbb7fc11d247fd33b4eee6d8167b3d2749d18d7023e86f0e738fd1437b3b2b1422abd6186b5babc5ddb2fc89c8e9148d0f533b310ac1c83013ea80f960cf6e065b046e3f6f272ed5fb6259aeded9a208440f7599b36420ab513ad07df3472cdd75cfcc8b767d44023239e721a7adcaaaad0f34f7c77e025497891234978b3a956595d9c239b342d4a0089ddd54b6cf9b5d58a32dd0f17fadc63056008b7b9a1db00cd7f63fba346b175ec57f8ffba398e70a3ce3117d3f0b8a9d78e5cd619270bba88b7cdb37e24523c5ea1b2f07d99e0369ea2310161bddaca5cc9bd7f2b6abf84d5759b31dc88202fceb64003b930ac5e552f4e3e93d82c0913afc1c02dfdf66f4a2f4e5bdd28a3fdc2cffcc686b5b73a64ce2a872c08e208aafcb76e7df9ebfafd49d3c2ca345ed2fe22828514782c78b6e9f867bd9de6918
```

Add ($De(En(a)+En(b))=a+b$):


```py
>>> cipher_sum = num1 + num2
>>> plain_sum = private_key.decrypt(cipher_sum)
>>> print(f"Their sum is encrypted as {cipher_sum.ciphertext(be_secure=False):x}")
>>> print(f"decrypted sum: {plain_sum}")
Their sum is encrypted as 41a992eaa94d6be9c4c3ab2bbcd911e840f3cbe3d1f2e66236864fb047277eb49e54c3be97313549965bd381c4de73b92b438d3828b015314396a65f43de1586a95e74d708092160e88cb6a96490811d017311a4a7f6966539db62c8cb19d01411468bb4d2e16103cc525cb83e35c2e1d2ae970af45b8f8d08ffb7ee96c4d708d3b6e37306e533ecabc84e015a8c5b1df03e05dd9f656dd630744b53cbc21ef6d4a07248084de82e0043777eda063b08d88447d3e9ec914a162d1efa6d0d31d26d8c80cf589f5b756cb9c9cddf11ae8b41dc8e5aa7599e94235c49348c64b56c637e7e1bb44722d7cab47969618e12ac440266473bddd63ad63cd330927a7d33c8cde0e7c1626f51b3986cd129fe4d33f6ce66f20e3fc72c599f3dc9eb9a7660941995fdbe028e1868473dc7e66cbc79457d61a472ce02909d8492d6df8ce2e2aa6d712003d90b9acc1cd6b0f831b840529f6c396b45e469a98031f7785fde15625db00b767c6ebd8f6a519e42f23537ca4039342e87f03d48f9d80d20f547a38f2a375175ead1506256b5b1bdff81fb0996dcb056d6b859c15c888d193e500b3ed1bc71246479917876f5159a51512bb301268b3d0383936ec5515d629e949d22d8347f65763ad3f8ed7787874b4ac90af2c937160a2bee1daafa67794ecd9f53d152774d7964c34605b35db03108a7118c4f2196e403728ef8140931d198ec
decrypted sum: 628
```

Substract ($De(En(a)-En(b))=a-b$):

```py
>>> cipher_sub = num2 - num1
>>> plain_sub = private_key.decrypt(cipher_sub)
>>> print(f"Their difference is encrypted as {cipher_sub.ciphertext(be_secure=False):x}")
>>> print(f"decrypted difference: {plain_sub}")
Their difference is encrypted as 1cdb92c04dee1573bea5d2448d43728f64a51bcecbe242f06708e2cd66354d43105079b6d7c09b173471bc644ce0a1f219e42dc11422e6f8bfd3a0e78a773b306c393d666b9c7dd3956cf2d821161dbf643c3a51efbcb664fd3413d795909e499436a0334079259a4678fc4ed770f5baf3023d0779db4fb0442f44d76bf1ed75c13d22e3334d075a19958c79a3ec47b5de936aea6363d67778e9c0f50a6a0a98e05293691b0d16119e52f582b9419cb3cf4b70ea53fa1e316e9de245308ba1e0e8503a85a1fe9fa4bc6b8f87496d90537cd62828227abd4b119da414e6ccf15cce91e2370c1d5ad68e3af6be5dd1a8eeb98ed8ea02df1d366de68f0fd5d8a76c55c74f617d9fe2a851067426f2c0858a25a8bee522bbd0310d428c6e421639662c76da64b80243dea5351aa7cbef199f3e4e8cab8f4e5c5417cda683fcff4a9ffef5c719ab0fdf38b2eb4e7a5a5977b6497e73f7c22a6888e594324b5513ae33b790370279757eea0e0713893f8ce9fc86f8b0d58a1db909f798395d385765f559dd1334003e0b7535289357e0387a10f06fd429cdc7b18f10866619a84963fed40e948175d7af8383d6f4b35e1bec472e11e185afd824c50ea8d97666da5b7a519cf1e170e7df61cc5da84f125d8c6d1351d171cb0578f43f473aa3f73f5d6555f8b7bd6387679cab7fc8a34f905794926a728eac539cf453abb317eb13a17d
decrypted difference: 400
```

Multiply ($De(k \cdot En(n))=kn$)

```py
>>> cipher_product = num1 * 3
>>> plain_product = private_key.decrypt(cipher_product)
>>> print(f"Their product is encrypted as {cipher_product.ciphertext(be_secure=False):x}")
>>> print(f"decrypted product: {plain_product}")
Their product is encrypted as 11e7b6b3eb8dfd206c71e10f6816a4ac9b6e0ef0524065ed683a2652d0c75ae959922ea82f5d6cb15cbcdb0d8a084b028a7be9bad3f71f1abd14f987631a1f093a11230be6238253aee8a2487385eb7368304085af757658d6a4c0b4b93452fc488b9c1aacdc9f2f39d12760e0c19a3cc7d900d77d3b313141f95d3569036625573cb85a98a89dbc47ca2adbb03564840785a967904cde0749dbb62c64c3cdfbf280a715c327a47c09416e3b07e714c07d66f0ecb5e4191950b7d28adbde4e79c7cb31d5a8426e1c73629a5c9976a255ce71d2a92cfe8b56eba84e020ff92754a0f0a10c1ef48ca662ba9dc61d2ec7faa02ecb447b253d094d9e5fa4c66f0680f7dd04d5117b9fa0ea75ccfbd02700f97fc03d017add3f1278aba9487a819938948532ae5ce2099e2c492dfc41b02971be8d5d40308873243dbc534e025b934518fc262fb1caa038fb34d4a4c20b0802c2b280a15e7a70a3d912b346c4425eebe12ac117a2e3f28adb3579f4f219381a0f964ec513bddca679a60a715bd2ef2e68567c6f9c563a6683e38b71ad94c6ba781af21c4f111d6055f05950ed4a7406c977871c4ad75d0d66d4a7a491880ab48a7f8b78c81b736105c29a40b1da4218b36792435fc42c305e36e383b72bb485450f71eeefb0d94a3bf06c580f7f20703ab380af6edc452e7ce763340b1d58bf1d719c6ebc358d6eced96c555f081bf9
decrypted product: 342
```

````{warning}
Since `phe` is an *additive* (**partially**) HE library, multiplication operation between two encrypted numbers, for example:

```python
num1, num2 = public_key.encrypt(114), public_key.encrypt(514)
cipher_times = num1 * num2
```

is not allowed, that is, the result will not be decrypted correctly. `*` can only be used between an encrypted number and a plain scalar number.
````

`````

`````{tabbed} CLI
Generate a key file and save it to `private_key.json`:

```
$ pheutil genpkey --keysize 1024 private_key.json
```

Extract the public key from `private_key.json` and save as `public_key.json`

```
$ pheutil extract private_key.json public_key.json
```

Encrypt int 114 and 514 using the public key and export the ciphertexts to `num1.enc` and `num2.enc` respectively:

```
$ pheutil encrypt --output num1.enc public_key.json 114
$ pheutil encrypt --output num2.enc public_key.json 514
```

Sum them up:

```
$ pheutil addenc --output sum.enc public_key.json num1.enc num2.enc
```

Decrypt the sum:

```
$ pheutil decrypt private_key.json sum.enc
```

````{warning}
Since `phe` is an *additive* (**partially**) HE library, multiplication operation between two encrypted numbers, for example:

```sh
# wrong
$ pheutil multiply public_key.json num1.enc num2.enc
```

is not allowed. `pheutil multiply` can only be used between an encrypted number and an uncrypted number, like

```sh
# fine
$ pheutil multiply public_key.json num1.enc 3
```

````

`````

### Fully HE

`````{tabbed} Python

Source code: {download}`fully-basic.py`

Create an empty `Pyfhel` object

```py
>>> from Pyfhel import Pyfhel
>>> HE = Pyfhel()
```

Initialize a context with plaintext modulo 65537 and generate a public/private key pair

```py
>>> HE.contextGen(p=65537)
>>> HE.keyGen()
```

Encrypt 114 and 514, then print the last 16 bytes of the ciphertexts

```py
>>> num1 = HE.encryptInt(114)
>>> num2 = HE.encryptInt(514)
>>> print(f"114 is encrypted as ...{num1.to_bytes()[-16:].hex()}")
>>> print(f"514 is encrypted as ...{num2.to_bytes()[-16:].hex()}")
114 is encrypted as ...7c66aaf3cd2d15000000000000000000
514 is encrypted as ...f01210914a5c23000000000000000000
```

Add

```py
>>> cipher_sum = num1 + num2
>>> plain_sum = HE.decrypt(cipher_sum, decode_value=True)
>>> print(f"Their sum is encrypted as ...{cipher_sum.to_bytes()[-16:].hex()}")
>>> print(f"decrypted sum: {plain_sum}")
Their sum is encrypted as ...6c79ba84188a38000000000000000000
decrypted sum: 628
```

Substract

```py
>>> cipher_sub = num2 - num1
>>> plain_sub = HE.decrypt(cipher_sub, decode_value=True)
>>> print(f"Their difference is encrypted as ...{cipher_sub.to_bytes()[-16:].hex()}")
>>> print(f"decrypted difference: {plain_sub}")
Their difference is encrypted as ...74ac659d7c2e0e000000000000000000
decrypted difference: 400
```

Mutiply

```py
>>> cipher_mul = num1 * num2
>>> plain_mul = HE.decrypt(cipher_mul, decode_value=True)
>>> print(f"Their product is encrypted as ...{cipher_mul.to_bytes()[-16:].hex()}")
>>> print(f"decrypted product: {plain_mul}")
Their product is encrypted as ...0010ecb42bb22e000000000000000000
decrypted product: 58596
```

<!-- ```{literalinclude} fully-basic.py
:language: python
:linenos:
``` -->

````{important}
The ciphertext length of an integer is 32828, encryted `114` and `514` share 28528 identical bytes.
````
`````