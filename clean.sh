#!/bin/sh

echo "This will destroy the CA and all keys, press enter to continue or ^C to abort."

read FOO

rm -rf CA/*
rm index.txt*
rm certs/*
rm csrs/*
rm private/*
rm newcerts/*

