#!/bin/bash

# build the CA

function make_ca_dirs { 
  # generate the directory structure and empty, default files for a given CA directory
  CADIR=`pwd`/$1

  if [ ! -d ${CADIR} ]; then 
    mkdir ${CADIR}
    mkdir ${CADIR}/csrs
    touch ${CADIR}/index.txt.attr
  fi

  for d in certs private newcerts; do
    if [ ! -d ${CADIR}/$d ]; then
       mkdir ${CADIR}/$d
       cat openssl.conf.template | sed -e 's@__REPLACE_ME__@'"${CADIR}"'\/@g' > ${CADIR}/openssl.conf
    fi
  done
  if [ ! -f ${CADIR}/serial ]; then
   echo 1000 > ${CADIR}/serial
  fi

  touch ${CADIR}/index.txt

}

function make_key {
  CADIR=$1

  echo
  echo "=== generate key for ${CADIR} ==="
  echo 
  echo "NOTE! Be sure to specify a common name when asked."
  echo

  if [ ! -f ${CADIR}/private/cacert.key ]; then 
      openssl genrsa -des3 -out ${CADIR}/private/cacert.key 2048
  fi

  if [ ! -s ${CADIR}/private/cacert.key ]; then 
      echo "Exit: Key creation failed."
      exit 1 
  fi

}

make_ca_dirs ROOT_CA
make_key ROOT_CA
make_ca_dirs INTERMEDIATE_CA
make_key INTERMEDIATE_CA
# use the key to sign itself
echo
echo "=== self-sign the root ==="
echo
if [ ! -f ./ROOT_CA/cacert.pem ]; then 
  openssl req -new -x509 -days 3650 -extensions v3_ca -sha256 -nodes \
      -key ./ROOT_CA/private/cacert.key -out ./ROOT_CA/cacert.pem \
      -config ./ROOT_CA/openssl.conf
fi

echo
echo "=== generate intermediate CSR ==="
echo

# generate the CSR for the intermediate, then sign that with the root.
openssl req -new -days 3650 -extensions v3_ca -sha256 -nodes \
      -key ./INTERMEDIATE_CA/private/cacert.key -out ./INTERMEDIATE_CA/csrs/intermediate.csr \
      -config ./ROOT_CA/openssl.conf
echo
echo "=== Final Setup: Sign the Intermediate with the Root ==="
echo

openssl ca -config ROOT_CA/openssl.conf \
           -extensions v3_ca \
           -out ./INTERMEDIATE_CA/cacert.pem \
           -infiles ./INTERMEDIATE_CA/csrs/intermediate.csr

if [ -f ./INTERMEDIATE_CA/cacert.pem ]; then
  cat ./ROOT_CA/cacert.pem ./INTERMEDIATE_CA/cacert.pem > ca.chain.pem 

  echo "All Done! To create a new certificate, use:"
  echo
  echo "./makecert.sh my.fqdn.goes.here"
  echo
  echo "The certificate chain is available in ca.chain.pem"
else 
  echo "Signing failed. Clean up with ./clean.sh and try again, or re-run the setupCA script."
fi

