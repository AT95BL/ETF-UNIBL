#!/bin/bash

#der u pem

for key in Keys/KeyInfo*
do
    echo $key
    sad=$(openssl rsautl -decrypt -in $key -inkey alice.key 2>error.txt)
    echo $sad
done

# Keys/KeyInfo47.enc je key za alice
# lozinka7387 aes-256-ctr Poruka33.txt
# HEJ Alice, USPJESNO STE OTKLJUCALI OVU PORUKU. BRZO KOPIRAJTE OVAJ TEKST U SKRIPTU I PREDJITE NA SLEDECI ZADATAK ;)!

