#!/bin/bash

ulazi="ulaz*"

for ulaz in $ulazi
do
	sadrzaj=`cat $ulaz`
	key=`openssl passwd -5 -salt $sadrzaj $ulaz`
	text=`openssl enc -aria-192-ofb -d -in sifrat.dec -k $key -out dec$ulaz.dec 2>error.txt`
done

dec="*.dec"

for dec in $dec
do
	bat $dec
done
