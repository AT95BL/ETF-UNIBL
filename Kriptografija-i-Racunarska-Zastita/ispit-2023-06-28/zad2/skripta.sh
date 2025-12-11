#!/bin/bash

potpisi="potpis*"
kljucevi="key*"

for potpis in $potpisi
do
	openssl enc -base64 -d -in $potpis -out base$potpis 2>error.txt
done

for potpis in $potpisi
do
	for kljuc in $kljucevi
	do
		r1=`openssl dgst -sha1 -signature base$potpis -prverify $kljuc ulaz.txt 2>error.txt`
		if [[ "$r1" =~ "OK" ]]; then
			echo $kljuc
			echo $potpis
		fi
		r2=`openssl dgst -sha1 -signature base$potpis -verify $kljuc ulaz.txt 2>error.txt`
		if [[ "$r2" =~ "OK" ]]; then
			echo $kljuc
			echo $potpis
		fi
	done
done

#key65.key potpis13.sign
