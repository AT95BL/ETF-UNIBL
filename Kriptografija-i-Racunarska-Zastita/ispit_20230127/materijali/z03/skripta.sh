#!/bin/bash

certs="client*"

for cert in $certs
do
    openssl verify -CAfile cacert.pem -verbose $cert 2>error.txt
done

#clientcert15.crt: OK
#clientcert27.crt: OK
#clientcert29.crt: OK

