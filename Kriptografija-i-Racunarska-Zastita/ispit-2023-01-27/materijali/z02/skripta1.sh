#!/bin/bash

otisci="otisak*.dec"                                                            # Skripti izlistas datoteke 'otisak*.dec' -- tako da se dalje u skripti moze iteracijom prolaziti kroz iste!    (Pogledaj kako to radim!!)
lozinke="lozinka*.txt"                                                          # Skripti izlistas datoteke 'lozinka*.txt' -- tako da se dalje u skripti moze iteracijom prolaziti kroz iste!   (Pogledaj kako to radim!!)

for otisak in $otisci; do                                                       # iteracija kroz datoteke prefiksa 'otisak' ..
    hash1=$(cat "$otisak")                                                      # hash1 - (Sa drugim $ referenciraj 'otisak') / Sa tako "$otisak" - spremi tekst za komandu 'cat' / Sve to neka sa prvim $ referencira hash1
    salt=$(echo "$hash1" | cut -d '$' -f 3)                                     # hash1 je sada tekstualni sadrzaj datoteke 'otisak*.dec'!! Odatle ces izvuci 'salt'!! Izvucemo salt!!  (NAUCI KOMANDU!!)
    
    for lozinka in $lozinke; do                                                 # iteracija kroz datoteke prefiksa 'lozinka' ..
        sadrzaj=$(cat "$lozinka")                                               # izvuci sadrzaj iz datoteke referencirane sa 'lozinka' ..  
        hash2=$(openssl passwd -apr1 -salt "$salt" "$sadrzaj")                  # ...
        if [ "$hash1" == "$hash2" ]; then
            echo -e "Otisak: $otisak Lozinka: $lozinka Sadrzaj: $sadrzaj"   
            break
        fi
    done
done 

# Rezultat:
# Otisak: otisak1.dec Lozinka: lozinka18.txt Sadrzaj: lozinka18
# Otisak: otisak2.dec Lozinka: lozinka3.txt Sadrzaj: lozinka3
# Otisak: otisak3.dec Lozinka: lozinka30.txt Sadrzaj: lozinka30

algoritmi=$(openssl enc -list | grep "aes-256")                                 #   (NAUCI KOMANDU!!)

lozinka1=$(cat lozinka30.txt)
lozinka2=$(cat lozinka3.txt)
lozinka3=$(cat lozinka18.txt)

for algoritam in $algoritmi
do
    
    openssl enc $algoritam -d -in sifrat.dec -out sifrat2.dec -k "$lozinka1" 2>error1.txt
    openssl enc $algoritam -d -in sifrat2.dec -out sifrat3.dec -k "$lozinka2" 2>error2.txt
    openssl enc $algoritam -d -in sifrat3.dec -out ulaz.dec -k "$lozinka3" 2>error3.txt
    cat ulaz.dec
    
done

# Rješenje:
# DANAS JE ISPIT IZ KRIPTOGRAFIJE
