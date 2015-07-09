# dirtyca

DirtyCA is a small collection of quick and dirty scripts to create a
self-signed root certificate authority for testing.

It will create a self-signed root certificate and sign an intermediate
certificate signed by the rootCA.

To make a new CA it, edit openssl-root.conf, and then run ./setupCA.sh.
To blow away the CA and start over, run ./clean.sh

Typically, you stash the root CA away and only use the Intermediate CA
for signing.


