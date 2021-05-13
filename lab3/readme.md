# Lab 3: Fine-grained Access Control with Attribute-based Encryption

> {sub-ref}`today` | {sub-ref}`wordcount-minutes` min to read

**Attribute-based encryption (ABE)** is a kind of algorithm of public-key cryptography in which the private key is used to decrypt data is dependent on certain user attributes such as position, place of residence, type of account [^cryto]. The idea of encryption attribute was first published in [*Fuzzy Identity-Based Encryption*](http://web.cs.ucla.edu/~sahai/work/web/2005%20Publications/Eurocrypt2005.pdf) and then developed as [*Attribute-Based Encryption for Fine-Grained Access Control of Encrypted Data*](https://web.cs.ucdavis.edu/~franklin/ecs228/pubs/abe.pdf).

[^cryto]: Attribute-based encryption: http://cryptowiki.net/index.php?title=Attribute-based_encryption


## Set-up

### Install OpenABE

[OpenABE](https://github.com/zeutro/openabe) is a cryptographic library that incorporates a variety of attribute-based encryption (ABE) algorithms, industry standard cryptographic functions and CLI tools, and an intuitive API

Download and install dependencies:

```
$ git clone https://github.com/zeutro/openabe
$ cd openabe
$ sudo -E ./deps/install_pkgs.sh
```

Compile:

```
$ source ./env
$ make
```

```{error}
If you encounter the error during `make`:

    ERROR: cannot verify github.com's certificate
Try

    $ sudo apt install ca-certificates
    $ printf "\nca_directory=/etc/ssl/certs" | sudo tee -a /etc/wgetrc

And then start from the very beginning again.
```

Run unit tests

```
$ make test
```

After all unit tests pass, install the `OpenABE` in a standard location (`/usr/local`):

```
$ make install
```

```{error}
If it fails with a write permission, try

    $ sudo -s
    # source ./env
    # make install
    # exit
```

Check if the CLI tools [^manual] set-up properly:

```sh
$ oabe_setup
# OpenABE command-line: system setup utility, v1.7
# usage: [ -s scheme ] [ -p prefix ] -v

#         -v : turn on verbose mode
#         -s : scheme types are 'CP' or 'KP'
#         -p : prefix string for generated authority public and secret parameter files (optional)
```

[^manual]: OpenABE CLI Util Document: https://github.com/zeutro/openabe/blob/master/docs/libopenabe-v1.0.0-cli-doc.pdf

## Ciphertext-Policy Attribute-based Encryption (CP-ABE)

In a CP-ABE (i.e. *role-based access control*) system , attributes are associated with users, while policies are associated with ciphertexts. A user can decrypt a certain ciphertext **if and only if** her attributes satisfy the policy.

For instance, we have three users:

Name | Age | Apartment 
---------|----------|---------
TDKR | 24 | Swimming club
MUR | 21 | Karate club
KMR | 25 | Karate club

A confidential document about Karate is encrypted, whose content can only be viewed by those users that belong to Karate club and have an age >= 24. In other words, only KMR can decrypt the file, TDKR or MUR cannot.

```sh
# generate a CP-ABE system with "inm" as its file name prefix
$ oabe_setup -s CP -p inm

# generate key for TDKR, MUR, and KMR with their attributes
$ oabe_keygen -s CP -p inm -i "Age=24|Swimming-club" -o TDKR_key
$ oabe_keygen -s CP -p inm -i "Age=21|Karate-club" -o MUR_key
$ oabe_keygen -s CP -p inm -i "Age=25|Karate-club" -o KMR_key

# Write a secret message into input.txt
$ echo "114514" > input.txt
# Encrpyt the file
$ oabe_enc -s CP -p inm -e "((Age > 22) and (Karate-club))" -i input.txt -o output.cpabe
```

Let's check:

```sh
# TDKR decrypts with TDKR's key -- should fail
$ oabe_dec -s CP -p inm -k TDKR_key.key -i output.cpabe -o TDKR_plain.txt

# MUR decrypts with MUR's key -- should fail
$ oabe_dec -s CP -p inm -k MUR_key.key -i output.cpabe -o MUR_plain.txt

# KMR decrypts with KMR's key -- should pass
$ oabe_dec -s CP -p inm -k KMR_key.key -i output.cpabe -o KMR_plain.txt
$ cat KMR_plain.txt
```

## Key-Policy Attribute-based Encryption (KP-ABE)

In a KP-ABE (i.e. *content-based access control*) system, policies are associated with users (i.e. their private keys), while attributes are associated with ciphertexts. A user can decrypt a ciphertext **if and only if** its attributes satisfy her (private key's) policy.

For example, as an employee of COAT corporation, TDKR can only access the emails to himself during his career in COAT (suppose Aug 1 - 31, 2019), which constructs his private key to decrypt files. All emails inside COAT are encrypted with their attributes (e.g. from, to, date, etc.) right after sent.

```sh
# generate a KP-ABE system with "COAT" as its file name prefix
$ oabe_setup -s KP -p COAT

# generate key slice for TDKR
$ oabe_keygen -s KP -p COAT -i "(To:TDKR and (Date = Aug 1-31, 2019))" -o TDKR_KP

# encrypt emails to different people at different time with their metadata
$ echo "Invitation to my big house this weekend." > input1.txt
$ oabe_enc -s KP -p COAT -e "From:TON|To:TDKR|Date=Aug 10,2019" -i input1.txt -o input1.kpabe
$ echo "How do you like CrossFit?" > input2.txt
$ oabe_enc -s KP -p COAT -e "From:Batman|To:TDKR|Date=May 14,2021" -i input2.txt -o input2.kpabe
$ echo "Let's go to have a drink!" > input3.txt
$ oabe_enc -s KP -p COAT -e "From:KMR|To:MUR|Date=Aug 14,2020" -i input3.txt -o input3.kpabe
```

Let's verify:

```sh
# decrypt the first email -- should pass
$ oabe_dec -s KP -p COAT -k TDKR_KP.key -i input1.kpabe -o input1_plain.txt
$ cat input1_plain.txt

# decrypt the second email -- should fail (date mismatches)
$ oabe_dec -s KP -p COAT -k TDKR_KP.key -i input2.kpabe -o input2_plain.txt

# decrypt the second email -- should fail (receiver mismatches)
$ oabe_dec -s KP -p COAT -k TDKR_KP.key -i input3.kpabe -o input3_plain.txt
```