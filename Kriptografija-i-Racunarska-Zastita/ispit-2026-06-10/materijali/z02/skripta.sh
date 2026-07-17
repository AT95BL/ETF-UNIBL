#!/bin/bash
#-aria-256-cbc

for s in sifrat*
do
    sad=$(openssl dgst -verify public.key -sha384 -signature potpis.txt $s 2>error.txt)
    
    if [[ "$sad" =~ "OK"  ]]
    then
        echo $s
    fi
done

# sifrat91.txt


openssl enc -aria-256-cbc -d -k sigurnost -in sifrat91.txt -out odg.txt

#Ulazni sadrzaj 49
