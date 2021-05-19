# Lab 4: Processing encrypted data with Homomorphic Encryption (HE)

**(Fully) Homomorphic Encryption (HE)** is a special class of encryption technique that allows for computations to be done on encrypted data, without requiring key to decrypt the ciphertext before operations and keep encrypted. It was first envisioned in 1978 [^rivest1978data] and constructed in 2009 [^gentry2009fully]. By applying HE to protect the customer's data on cloud, the cloud service can perform the computation directly on the given data with a state-of-the-art cryptographic security guarantee.

```{seealso}
In general, a *fully* homomorphic encryption system supports both addition and multiplication operartions, while a *partially* homomorphic encryption may only enable one of them (e.g. [Paillier cryptosystem](https://en.wikipedia.org/wiki/Paillier_cryptosystem) is one implementation of partially homomorphic encryption that supports only addition operation [^paillier1999public]).
```

[^paillier1999public]: Paillier, Pascal. "[Public-key cryptosystems based on composite degree residuosity classes](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.2.8294&rep=rep1&type=pdf)." In *International conference on the theory and applications of cryptographic techniques*, pp. 223-238. Springer, Berlin, Heidelberg, 1999.

[^rivest1978data]: Rivest, Ronald L., Len Adleman, and Michael L. Dertouzos. "[On data banks and privacy homomorphisms](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.500.3989&rep=rep1&type=pdf)." *Foundations of secure computation* 4, no. 11 (1978): 169-180.

[^gentry2009fully]: Gentry, Craig. "[Fully homomorphic encryption using ideal lattices](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.362.7592&rep=rep1&type=pdf)." In *Proceedings of the forty-first annual ACM symposium on Theory of computing*, pp. 169-178. 2009.

## Set-up

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


````{tabbed} C++
Install [HElib](https://homenc.github.io/HElib/) (v2.1.0)

```
$ wget https://github.com/homenc/HElib/archive/refs/tags/v2.1.0.tar.gz
$ tar xzvf v2.1.0.tar.gz
$ cd HElib-2.1.0
$ mkdir build
$ cd build
$ cmake -DPACKAGE_BUILD=ON -DCMAKE_INSTALL_PREFIX=~/helib_install ..
$ make
$ make install
```

````

## Basic Property

### Partially HE

`````{tabbed} Python

Source code: {download}`partially-basic.py`

```{literalinclude} partially-basic.py
:language: python
:linenos:
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

```{literalinclude} fully-basic.py
:language: python
:linenos:
```

````{important}
The ciphertext length of an integer is 32828, encryted `114` and `514` share 28528 identical bytes.
````
`````