#!/bin/bash

# Lista otisaka koje treba pronaci
otisci=(otisak1.dec otisak2.dec otisak3.dec)

for otisak_datoteka in "${otisci[@]}"; do
    echo "Trazi se kljuc za: $otisak_datoteka"
    hash1=$(cat "$otisak_datoteka")

    for lozinka_datoteka in lozinka*.txt; do
        t=$(cat "$lozinka_datoteka")
        # Pretpostavimo da je 'wAGnh5WA' salt za SVE
        hash2=$(openssl passwd -apr1 -salt wAGnh5WA "$t")

        if [ "$hash1" == "$hash2" ]; then
            echo -e "Pronadjena lozinka za $otisak_datoteka: $lozinka_datoteka (Sadrzaj: $t)"
            break
        fi
    done
done

# openssl enc -d -aes-256-cbc -in sifrat1.txt -out ulaz.txt -pass file:lozinka18.txt