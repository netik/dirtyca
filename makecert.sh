#!/bin/sh

export INTERMEDIATE_CONF=`pwd`/INTERMEDIATE_CA/openssl.conf

if [ "$1" == "" ]; then
  echo "usage: $0 fqdn.goes.here.com"
  echo 
  exit 127
fi

FQDN=$1
KEYFILE=./INTERMEDIATE_CA/private/${FQDN}.key
CSRFILE=./INTERMEDIATE_CA/csrs/${FQDN}.csr 
CERTOUT=./INTERMEDIATE_CA/certs/${FQDN}.cert

if [ -f ${KEYFILE} ]; then 
  echo "${KEYFILE}.key exists. Remove it before re-generating."
  exit 1
fi

echo
echo "=== genkey ==="
openssl genrsa -out ${KEYFILE} 2048

echo
echo "=== request csr ==="

if [ ! -d ./INTERMEDIATE_CA/csrs ];
then
  mkdir ./INTERMEDIATE_CA/csrs
fi

# create request
echo "




${FQDN}




" | openssl req -config ${INTERMEDIATE_CONF} -new -key ${KEYFILE} -out ${CSRFILE}

echo 
echo "=== sign ==="

# sign the request with the Intermediate CA
openssl ca -config ${INTERMEDIATE_CONF} -policy policy_anything \
    -out ${CERTOUT} -infiles ${CSRFILE}

# and store the server files in the certs/ directory<br />
#mv ${FQDN}.csr ${FQDN}.cert certs/

echo "=== done ==="

echo "Certificate is available in:"
echo ${CERTOUT}
