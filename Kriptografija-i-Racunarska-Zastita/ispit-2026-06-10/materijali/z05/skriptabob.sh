#!/bin/bash

#der u pem

for key in Keys/KeyInfo*
do
    echo $key
    sad=$(openssl rsautl -decrypt -in $key -inkey bob.key 2>error.txt)
    echo $sad
done

# Keys/KeyInfo26_.enc za boba
# lozinka4678 aes-128-cfb1 Poruka2.txt
# HEJ Bob, USPJESNO STE OTKLJUCALI OVU PORUKU. BRZO KOPIRAJTE OVAJ TEKST U SKRIPTU I PREDJITE NA SLEDECI ZADATAK ;)!
