#!/bin/sh

export INTERMEDIATE_CONF=`pwd`/INTERMEDIATE_CA/openssl.conf

if [ "$1" == "" ]; then
  echo "usage: $0 fqdn.goes.here.com [-f]"
  echo
  echo "    -f  Force generation of new key"
  echo "    -s  Do not generate a key or csr, just sign the csr."
  echo "        You must have an existing CSR and KEY."
  echo 
  exit 127
fi

FQDN=$1
KEYFILE=./INTERMEDIATE_CA/private/${FQDN}.key
CSRFILE=./INTERMEDIATE_CA/csrs/${FQDN}.csr 
CERTOUT=./INTERMEDIATE_CA/certs/${FQDN}.cert

if [ "$2" != "-s" ]; then
    if [ -f ${KEYFILE} -a "$2" != "-f" ]; then 
	echo "${KEYFILE}.key exists. Remove it before re-generating."
	exit 1
    fi
    
    echo
    echo "=== Generate Key ==="
    if [ "$2" == "-f" ]; then 
	echo " * Forcibly regenerating the key for $FQDN"
    fi
    echo
    
    openssl genrsa -out ${KEYFILE} 2048
    
    echo
    echo "=== Generate Request CSR ==="
    echo
    if [ ! -d ./INTERMEDIATE_CA/csrs ];
    then
	mkdir ./INTERMEDIATE_CA/csrs
    fi
    
# create request
echo "




${FQDN}




" | openssl req -config ${INTERMEDIATE_CONF} -new -key ${KEYFILE} -out ${CSRFILE}

fi 

# sanity check
if [ ! -f ${KEYFILE} -o ! -f ${CSRFILE} ]; then
    echo "ERROR: Either the CSR file or the Keyfile is missing."
    exit 127
fi

echo
echo 
echo "=== Sign Request with Intermediate ==="
echo



# sign the request with the Intermediate CA
openssl ca -config ${INTERMEDIATE_CONF} -policy policy_anything 
    -extensions v3_req \
    -out ${CERTOUT} -infiles ${CSRFILE}

# and store the server files in the certs/ directory<br />
#mv ${FQDN}.csr ${FQDN}.cert certs/

if [ -f ${CERTOUT} ]; then
    echo
    echo "=== Complete ==="
    echo
    
    echo "Certificate: ${CERTOUT}"
    echo "Private Key: ${KEYFILE}"
    echo "   CA Chain: `pwd`/ca.chain.pem"
else
    echo
    echo "=== Signing failed! ==="
    echo
    echo "You can retry signing again with the -s or -f options."
fi

