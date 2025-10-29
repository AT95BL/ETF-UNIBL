#!/bin/bash

algoritmi=`openssl enc -list | grep "aes-256"`
`openssl enc -d -base64 -in sifrat.txt -out sifrat.dec`
lozinka1=`cat lozinka30.txt`
lozinka2=`cat lozinka3.txt`
lozinka3=`cat lozinka18.txt`
for algoritam in $algoritmi
do
    
    `openssl enc $algoritam -d -in sifrat.dec -out sifrat2.dec -k "$lozinka1" 2>error1.txt`
    `openssl enc $algoritam -d -in sifrat2.dec -out sifrat3.dec -k "$lozinka2" 2>error2.txt`
    `openssl enc $algoritam -d -in sifrat3.dec -out ulaz.dec -k "$lozinka3" 2>error3.txt`
    cat ulaz.dec
    
done

#DANAS JE ISPIT IZ KRIPTOGRAFIJE
    
