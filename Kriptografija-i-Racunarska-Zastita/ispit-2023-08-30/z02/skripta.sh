#!/bin/bash

potpisi="potpis*"

for potpis in $potpisi
do
	openssl enc -base64 -d -in $potpis -out base$potpis
done

kljucevi="key*"
basePotpisi="base*"
for potpis in $basePotpisi
do
	for kljuc in $kljucevi
	do
		result=`openssl dgst -sha1 -prverify $kljuc -signature $potpis ulaz.txt 2> error.txt`
		if [[ $result == "Verified OK" ]] then
			echo "$potpis"
			echo "$kljuc"
		fi
		result2=`openssl dgst -sha1 -verify $kljuc -signature $potpis ulaz.txt 2>error.txt`
		if [[ $result2 == "Verified OK" ]] then
			echo "$potpis"
			echo "$kljuc"
		fi

	done
done

#potpis13.sign key59.key
