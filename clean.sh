#!/bin/sh

echo "This will destroy the CA and all keys, press enter to continue or ^C to abort."

read FOO

rm -rf ROOT_CA
rm -rf INTERMEDIATE_CA
