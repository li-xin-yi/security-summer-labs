# Lab 3: Fine-grained Access Control with Attribute-based Encryption

> {sub-ref}`today` | {sub-ref}`wordcount-minutes` min to read

**Attribute-based encryption (ABE)** is a kind of algorithm of public key cryptography in which the private key is used to decrypt data is dependent on certain user attributes such as position, place of residence, type of account [^cryto]. The idea of encryption attribute was first published in [*Fuzzy Identity-Based Encryption*](http://web.cs.ucla.edu/~sahai/work/web/2005%20Publications/Eurocrypt2005.pdf) and then developed as [*Attribute-Based Encryption for Fine-Grained Access Control of Encrypted Data*](https://web.cs.ucdavis.edu/~franklin/ecs228/pubs/abe.pdf).

[^cryto]: Attribute-based encryption: http://cryptowiki.net/index.php?title=Attribute-based_encryption


## Set up

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

