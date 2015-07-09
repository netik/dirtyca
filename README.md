# dirtyca

DirtyCA is a small collection of _quick and dirty_ scripts to create a
self-signed root certificate authority for testing.

It will create a self-signed root certificate and then sign an intermediate
certificate with the RootCA. 

By default certificates are 2048-bit RSA, signed with SHA-256.

# Install

The only requirement is that you have a current version of openSSL
installed.

* To make a new CA ust run ./setupCA.sh.
* To blow away the CA and start over, run ./clean.sh

# Notes

If you'd like to change the X509 certificate data for the CA, modify
openssl-template.conf before running setupCA.sh

When running setupCA.sh must have a common name for each of the CA's. I prefer names, with
versioning such as "Acme Primary Root CA Version 1" and "Acme Primary
Intermediate CA Version 1".

---
John Adams <jna@retina.net>
7/2015
