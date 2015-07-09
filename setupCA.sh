#!/bin/bash

# build the CA
if [ ! -d CA ]; then 
  mkdir ./CA
  mkdir ./CA/csrs
  touch ./CA/index.txt.attr
fi

for d in certs private newcerts; do
  if [ ! -d ./CA/$d ]; then
     mkdir ./CA/$d
     cat openssl-root.conf | sed -e 's/__REPLACE_ME__/`pwd`\/CA/g' > ./CA/openssl.conf
  fi
done

# update serial
cd CA
if [ ! -f serial ]; then
  echo 1000 > serial
fi

touch index.txt

echo
echo "=== generate key ==="
echo

if [ ! -f private/cacert.key ]; then 
  openssl genrsa -des3 -out private/cacert.key 2048
fi

if [ ! -s private/cacert.key ]; then 
    echo "Exit: Key creation failed."
    exit 1 
fi

# use the key to sign itself
echo
echo "=== self-sign the root ==="
echo
if [ ! -f cacert.pem ]; then 
  openssl req -new -x509 -days 3650 -extensions v3_ca -sha256 -nodes \
      -key private/cacert.key -out cacert.pem \
      -config openssl.conf
fi

# create the intermedite key and cert
openssl genrsa -des3 -out private/intermediate-ca.key 2048

# sign the intermediate CSR 
openssl req -new -x509 -days 3650 -extensions v3_ca -sha256 -nodes \
      -key private/cacert.key -out intermediate-ca.pem \
      -config openssl.conf

echo "Ok, we're done. You can use:"
echo
echo "./makecert.sh my.fqdn.goes.here"
echo
echo "to create certificates."
