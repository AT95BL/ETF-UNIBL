#!/bin/bash

clientcerts="clientcert*"

for cert in $clientcerts
do
	r=`openssl verify -CAfile cacert.pem -verbose $cert 2>error.txt`
	if [[ "$r" =~ "OK" ]] then
		echo $cert
	fi
done

#clientcert16.crt
#clientcert18.crt
#clientcert20.crt
