#!/bin/bash

sifrati="sifrat*"

hash=$(cat otisak.hash)

for sifrat in $sifrati
do
	openssl enc -aes-192-cbc -base64 -d -k sigurnost -in $sifrat -out b$sifrat 2>error.txt
	r=$(openssl dgst -sha3-384 b$sifrat | cut -d ' ' -f 2)
	if [[ "$r" == "$hash" ]] then
		echo $sifrat
	fi

	r2=$(openssl dgst -sha384  b$sifrat | cut -d ' ' -f 2)
	if [[ "$r2" == "$hash" ]] then
		echo $sifrat
	fi
done

#sifrat100.txt
#Ulazni sadrzaj
