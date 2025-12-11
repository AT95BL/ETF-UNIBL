#!/bin/bash

crls="crl*"
certs="cert*"

for cert in $certs
do
	serialNum=`openssl x509 -in $cert -noout -text | grep "Serial Number:" | cut -d "x" -f 2 | cut -d ')' -f 1  `
       for crl in $crls
       do
	      crlText=`openssl crl -in $crl -noout -text`
	      if [[ "$crlText" == *"$serialNum"* ]] then
		    echo -e $cert
		    break
	     fi
	 
       done       
done

#Cert koji se nalaze su 1 2 4 9
