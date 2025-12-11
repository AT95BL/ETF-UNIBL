#!/bin/bash

otisak1=`cat otisak1.dec`
otisak2=`cat otisak2.dec`
otisak3=`cat otisak3.dec`
lozinke="lozinka*"

for lozinka in $lozinke
do
	a=`openssl passwd -apr1 -salt lozinka1 $(<$lozinka)`
	b=`openssl passwd -apr1 -salt lozinka7 $(<$lozinka)`
	c=`openssl passwd -apr1 -salt wAgnh5WA $(<$lozinka)`

	if [[ "$a" == "$otisak1" ]] then
		echo "otisak1"
		echo "$lozinka"
	fi

	if [[ "$b" == "$otisak2" ]] then
		echo "otisak2"
		echo "$lozinka"
	fi

	if [[ "$c" == "$otisak3" ]] then
		echo "otisak3"
		echo "$lozinka"
	fi

done

algs=`openssl enc -list | grep "aes-256"`
lozinka1=$(<lozinka30.txt)
lozinka2=$(<lozinka3.txt)
lozinka3=$(<lozinka18.txt)

for alg in $algs
do
	openssl enc $alg -d -in sifrat.dec -out sifrat1.dec -k $lozinka1 2>error.txt
	openssl enc $alg -d -in sifrat1.dec -out sifrat2.dec -k $lozinka2 2>error.txt
	openssl enc $alg -d -in sifrat2.dec -out sifrat3.dec -k $lozinka3 2>error.txt
	cat sifrat3.dec
done
#lozinka18.txt
#lozinka3.txt
#lozinka30.txt

#DANAS JE ISPIT IZ KRIPTOGRAFIJE⏎ 
