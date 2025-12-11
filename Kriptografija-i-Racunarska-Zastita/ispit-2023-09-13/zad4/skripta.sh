#!/bin/bash

mkdir certs
mkdir keys
mkdir rsaKeys
for i in {1..6}
do
	keytool -exportcert -alias s$i -keystore store.jks -file certs/cert$i.pem -storepass sigurnost 2>error.txt
	keytool -exportcert -alias s$i -keystore store2.jks -file certs/cert2$i.pem -storepass sigurnost 2>error.txt
	openssl x509 -in certs/cert$i.pem -pubkey -noout > keys/pubkey$i.pem
	openssl x509 -in certs/cert2$i.pem -pubkey -noout > keys/pubkey2$i.pem
done

keys="key*"

for key in $keys
do
	openssl rsa -in $key -pubout > rsaKeys/$key.pub
done

for key in $keys
do
	pubkey=$(<rsaKeys/$key.pub)
	for i in {1..6}
	do
		pubkey2=$(<keys/pubkey$i.pem)

		if [[ "$pubkey" == "$pubkey2" ]] then
			for j in {1..6}
			do
				pubkey3=$(<keys/pubkey2$j.pem)
				if [[ "$pubkey" == "$pubkey3" ]] then
					echo -e "$key"
					break
				fi
			done
		fi
	done
done


#key86.key
#key98.key
