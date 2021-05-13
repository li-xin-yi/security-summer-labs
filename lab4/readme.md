# Lab 4: Processing encrypted data with Homomorphic Encryption (HE)

**(Fully) Homomorphic Encryption (HE)** is a special class of encryption technique that allows for computations to be done on encrypted data, without requiring key to decrypt the ciphertext before operations and keep encrypted. It was first envisioned in 1978 [^rivest1978data] and constructed in 2009 [^gentry2009fully]. By applying HE to protect the customer's data on cloud, the cloud service can perform the computation directly on the given data with a state-of-the-art cryptographic security guarantee.

[^rivest1978data]: Rivest, Ronald L., Len Adleman, and Michael L. Dertouzos. "[On data banks and privacy homomorphisms](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.500.3989&rep=rep1&type=pdf)." *Foundations of secure computation* 4, no. 11 (1978): 169-180.

[^gentry2009fully]: Gentry, Craig. "[Fully homomorphic encryption using ideal lattices](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.362.7592&rep=rep1&type=pdf)." In *Proceedings of the forty-first annual ACM symposium on Theory of computing*, pp. 169-178. 2009.
