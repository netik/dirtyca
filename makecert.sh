#!/bin/sh

export INTERMEDIATE_CONF=`pwd`/CA/openssl.conf

if [ "$1" == "" ]; then
  echo "usage: $0 fqdn.goes.here.com"
  echo 
  exit 127
fi

FQDN=$1

if [ -f ./CA/private/${FQDN}.key ]; then 
  echo "${FQDN}.key exists. Remove it before re-generating."
  exit 1
fi

echo
echo "=== genkey ==="
openssl genrsa -out ./CA/private/${FQDN}.key 2048


echo
echo "=== request csr ==="

if [ ! -d ./CA/csrs ];
then
  mkdir ./CA/csrs
fi

# create request
echo "




${FQDN}




" | openssl req -config ${INTERMEDIATE_CONF} -new -key ./CA/private/${FQDN}.key -out ./CA/csrs/${FQDN}.csr 

# debug: show us the req
#openssl req -in ./CA/csrs/${FQDN}.csr -text | more

echo 
echo "=== sign ==="

# sign the request with the Intermediate CA
openssl ca -config ${INTERMEDIATE_CONF} -policy policy_anything \
    -out ./CA/certs/${FQDN}.cert -infiles ./CA/csrs/${FQDN}.csr

# and store the server files in the certs/ directory<br />
#mv ${FQDN}.csr ${FQDN}.cert certs/

echo "=== done ==="
