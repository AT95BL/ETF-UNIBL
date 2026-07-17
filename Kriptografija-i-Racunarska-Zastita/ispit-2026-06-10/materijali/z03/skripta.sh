#!/bin/bash

for dat in client*
do
    openssl pkcs12 -in $dat -out ca.crt -cacerts -nokeys -passin pass:sigurnost -passout pass:sigurnost 2>error.txt
    
    sad=$(openssl verify -CAfile ca.crt s1.crt 2>error2.txt)
    #echo $dat $sad
    #echo .
    if [[ "$sad" =~ "OK" ]]
    then
        echo $dat $sad
        break
    fi
done

# client6.p12 s1.crt: OK
# komanda je openssl verify -CAfile ca.crt s1.crt 
# gdje je ca.crt izvuceni cert iz p12 za client6.p12 tad se breaka i on ostaje taj

# U pratećim materijalima je dat sertifikat s1.crt, kao i niz PKCS#12 datoteka.
# U jednoj od PKCS#12 datoteka se nalazi sertifikat CA tijela koje je izdalo s1.crt.
#
# Znači da ćeš morati redom prolaziti, jednu po jednu pkcs12 datoteku, otpakuješ je i provjeriš da li
# ista sadrži CA tijelo koje je potpisalo serfitikat s1.crt!!

