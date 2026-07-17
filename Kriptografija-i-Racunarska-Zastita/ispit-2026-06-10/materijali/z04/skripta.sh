#!/bin/bash

#otisak je b64 treba decode

openssl enc -d -a -in otisak.txt -out otisak.dec

# $6$ulaz13.txt$M1IRyjj7XOSWV.FBwvXGvJGRCDsSKbpl8ntSdjIP3fPJkD6YHiHZpaeebehLuZ9rRsK61U/9lMeN9C5i0wfIo/
# otisak encoded

contr=$(cat otisak.dec)
#echo $contr

for dat in ulaz*
do
    otisak=$(openssl passwd -6 -salt ulaz13.txt $dat)
    
    if [[ "$otisak" == "$contr" ]]
    then
        echo "kljuc je u dat:"
        echo $dat
    fi
done

#kljuc je u dat:
#ulaz22.txt
#kljuc: NERACIONALAN
#sifrat nisam uradio

