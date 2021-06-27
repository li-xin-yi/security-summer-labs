# Lab 3: Fine-grained Access Control with Attribute-based Encryption

**Attribute-based encryption (ABE)** is a kind of algorithm of public-key cryptography in which the private key is used to decrypt data is dependent on certain user attributes such as position, place of residence, type of account [^cryto]. The idea of encryption attribute was first published in [*Fuzzy Identity-Based Encryption*](http://web.cs.ucla.edu/~sahai/work/web/2005%20Publications/Eurocrypt2005.pdf) and then developed as [*Attribute-Based Encryption for Fine-Grained Access Control of Encrypted Data*](https://web.cs.ucdavis.edu/~franklin/ecs228/pubs/abe.pdf).

[^cryto]: Attribute-based encryption: http://cryptowiki.net/index.php?title=Attribute-based_encryption


## Set-up

### Install OpenABE

[OpenABE](https://github.com/zeutro/openabe) is a cryptographic library that incorporates a variety of attribute-based encryption (ABE) algorithms, industry standard cryptographic functions and CLI tools, and an intuitive API

Download and install dependencies:

```
$ sudo apt install python3-pip openssl
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

````{error}
If you encounter the error during `make`:

```
libssh.so.4: undefined symbol: evp_pkey_get_raw_public_key, and version OPENSSL_1_1
```
and you can run `curl`,`openssl` normally in other shells (or after `make clean` in this shell)

try

```
$ export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
```

in which `/usr/lib/x86_64-linux-gnu/` is an example path of `libssl.so`

````

````{error}
If you encounter the error during `make`:

```
../openabe/bin/bison: Command not found
```

Install `bison` and add the binary (suppose it in `/usr/bin`, you can find its location by `which bison`) to the folder

```
$ sudo apt install bison
$ ln -s /usr/bin/bison /absolute-path-of-openabe/openabe/bin/bison
```

````

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

Name | Age | Department 
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

## CP-ABE Exercises

Let's use the scenarios of "*Harry Potter and the Order of the Phoenix*" to practice CP-ABE. As Umbridge's control over Hogwarts campus increases, Ron and Hermione aid Harry in forming a secret group, "*Dumbledore's Army*(DA)", to train students in defensive spells. Some students joining in the DA are listed as below:


Character | House| Year | Gender
-----|----|----|---
Harry | Gryffindor | 5th | Male
Ron | Gryffindor | 5th | Male
Hermione | 	Gryffindor | 5th | Female
Cho | Ravenclaw | 6th | Female
Luna | Ravenclaw | 5th | Female
Ginny | Gryffindor | 4th | Female

One day, Hermione is going to hold a meeting about teaching *Expecto Patronum*, which is a very hard spelling and can only be mastered by senior (>= fifth year) students, in the Gryffindor common room. She has to encrypt a magic message sent by a shared owl, Errol. in DA, which means the message may be delivered to any DA member or even anyone in Hogwarts. However, she wants the message to be only viewable to senior students in Gryffindor House.

First, we should create a CP-ABE crypto-system called "DA"

```
$ oabe_setup -s CP -p DA
$ oabe_keygen -s CP -p DA -i "Gryffindor|Year=5|Male" -o harry_key
$ oabe_keygen -s CP -p DA -i "Gryffindor|Year=5|Male" -o ron_key
$ oabe_keygen -s CP -p DA -i "Gryffindor|Year=5|Female" -o hermione_key
$ oabe_keygen -s CP -p DA -i "Ravenclaw|Year=6|Female" -o cho_key
$ oabe_keygen -s CP -p DA -i "Ravenclaw|Year=5|Female" -o luna_key
$ oabe_keygen -s CP -p DA -i "Gryffindor|Year=4|Female" -o ginny_key
```

Then, Hermione writes the massage and encrypted it with a public key.

```
$ echo "Go to meet in Gryffindor common room at 7 p.m., Let's talk about how to teach Expecto Patronum" > invitation.txt

$ oabe_enc -s CP -p DA -e "((Year>=5) and (Gryffindor))" -i invitation.txt -o invitation.cpabe
```

Finally, we verify who can decrypt the invitation message:

```
$oabe_dec -s CP -p DA -k harry_key.key -i invitation.cpabe -o harry_invitation.txt
...
```

Only Harry, Ron and Hermione can view the invitation information.


## KP-ABE Exercises

Let's take an exercise from the scenes of "*The Avengers*" to practice KP-ABE. *The Avengers* is an organization founded by S.H.I.E.L.D Director Nick Fury on May 4, 2012, all members in the team are gifted superheroes that are committed to protect the world from a variety of threats. Superheros are assigned with different missions and often communicate with encrypted messages that can only be decrypted by certain receivers who are temporarily **out of** the organization HQ, which means **their secret key can only decrypt messages to themselves sent on the dates when they are not in the Avengers Tower** and prevents the secret message from being stolen by Hydra. Iron Man is the first member who joined the Avengers when it was founded. However, he disagreed with Captain America on the *Sokovia Accords* and determinedly left the Avengers on April 6, 2016. After a month, He discovered the misunderstood truth and accepted an apology from Captain America, so he returned to the group.

Now, Iron Man accidentally finds four encrypted notes in Avengers Tower, their metadata is listed below:

1. This message was sent from Thor to Hulk, dated on May 10, 2012
2. This message was sent from Black Widow to Iron Man, dated on April 22, 2016
3. This message was sent from Hawkeye to Captain America, dated on May 3, 2016
4. This message was sent from Captain America to Iron Man, dated on Sep 20, 2017

Construct Iron Man's secret key:

```
$ oabe_setup -s KP -p avengers
$ oabe_keygen -s KP -p avengers -i "(To:Iron_Man and (Date = April 6-30,2016 or Date = May 1-5,2016))" -o iron_man_key
```

Construct the ciphertexts of the four messages:

```
$ echo "note1" > note1.txt
$ echo "note2" > note2.txt
$ echo "note3" > note3.txt
$ echo "note4" > note4.txt
$ oabe_enc -s KP -p avengers -e "From:Thor|To:Hulk|Date = May 10, 2012" \
          -i note1.txt -o note1.kpabe
$ oabe_enc -s KP -p avengers -e "From:Black_Widow|To:Iron_Man|Date = April 22,2016" \
          -i note2.txt -o note2.kpabe
$ oabe_enc -s KP -p avengers -e "From:Hawkeye|To:Captain_America|Date = May 3, 2016" \
          -i note3.txt -o note3.kpabe
$ oabe_enc -s KP -p avengers -e "From:Captain_America|To:Iron_Man|Date = Sep 20, 2017" \
          -i note4.txt -o note4.kpabe
```

Verify which encrypted notes can be decrypted by Iron Man:

```
$ oabe_dec -s KP -p avengers -k iron_man_key.key -i note1.kpabe -o iron_man_note1.txt
$ oabe_dec -s KP -p avengers -k iron_man_key.key -i note2.kpabe -o iron_man_note2.txt
$ oabe_dec -s KP -p avengers -k iron_man_key.key -i note3.kpabe -o iron_man_note3.txt
$ oabe_dec -s KP -p avengers -k iron_man_key.key -i note4.kpabe -o iron_man_note4.txt
```

Only the second message can be decrypted.
