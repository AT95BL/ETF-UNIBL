#!/bin/bash

kljucevi="kljuc*"
privKey=$(<priv.key)
for kljuc in $kljucevi
do
	openssl rsa -in $kljuc -inform DER -out pem$kljuc -outform PEM

	if [[ "$privKey" =~ "$(<pem$kljuc)" ]] then
	echo $otisak
		echo "$kljuc"
	fi
done

#kljuc91.key
