#!/bin/bash

stores="store*"

for store in $stores
do
	openssl pkcs12 -in $store -nocerts -out keys/key$store.key -passin pass:sigurnost -passout pass:sigurnost
done

keys=`ls keys/`

for key in $keys
do
	rezultat=`openssl rsautl -decrypt -in envelopa.txt -inkey keys/$key -passin pass:sigurnost`
	if [[ $rezultat != "" ]]; then
		echo $rezultat
	fi
done

#Ajmo sad četvrti :).
