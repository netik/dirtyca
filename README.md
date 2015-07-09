# dirtyca

This is a small collection of _quick and dirty_ scripts to create a
self-signed root certificate authority with chained intermediate
certificate for testing. 

By default certificates are 2048-bit RSA, signed with SHA-256.

With some minor changes to the openssl template file, you could
even use this to run a small company's internal PKI. 

# Install

The only requirement is that you have a current version of openSSL
installed and in your PATH.

* To make a new CA run ./setupCA.sh.
* To blow away the CA and start over, run ./clean.sh

# Notes

If you'd like to change the X509 certificate data for the CA, modify
openssl-template.conf before running setupCA.sh

When running setupCA.sh you must  have a commonName set for each of the CA's. 
I prefer to use names with versioning such as "Acme Primary Root CA Version 1"
and "Acme Primary Intermediate CA Version 1". It makes things 
easier later when you're trying to walk the chain of a certificate during
debugging.

---
John Adams <jna@retina.net>

7/2015
