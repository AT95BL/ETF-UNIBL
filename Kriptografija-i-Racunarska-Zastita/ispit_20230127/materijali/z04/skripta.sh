#!/bin/bash

otisci=`cat otisci.dec`
ulazi="ulaz*"

for otisak in $otisci
do
    algoritam=`echo "$otisak" | cut -d '$' -f 2`
    salt=`echo "$otisak" | cut -d '$' -f 3`
    
    for ulaz in $ulazi
    do
        sadrzaj=`cat "$ulaz"`
        otisak2=`openssl passwd -$algoritam -salt "$salt" "$sadrzaj" 2>error1.txt`
        #echo -e "Otisak1: $otisak"
        #echo -e "otisak2: $otisak2"
        if [[ "$otisak" == "$otisak2" ]]
            then
                echo -e "Datoteka: $ulaz"
                echo -e "Algoritam: $algoritam"
                #echo -e "Otisak: $otisak"
                break
        fi
    done
done

#Datoteka: ulaz14.txt
#Algoritam: 1

#Datoteka: ulaz22.txt
#Algoritam: 5

#Datoteka: ulaz40.txt
#Algoritam: apr1

#Datoteka: ulaz41.txt
#Algoritam: 6

        
