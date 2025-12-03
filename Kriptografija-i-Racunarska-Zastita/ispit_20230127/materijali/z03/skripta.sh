#!/bin/bash

certs="client*"
i=1

for cert in $certs; 
do 
   echo "$i. Cert .."
    i=$((i+1)) 
   openssl verify -CAfile cacert.pem -verbose $cert 2>error.txt
done
