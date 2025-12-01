#!/bin/bash

otisci="otisak*.dec"                                                            # Skripti izlistas datoteke 'otisak*.dec' -- tako da se dalje u skripti moze iteracijom prolaziti kroz iste!    (Pogledaj kako to radim!!)
lozinke="lozinka*.txt"                                                          # Skripti izlistas datoteke 'lozinka*.txt' -- tako da se dalje u skripti moze iteracijom prolaziti kroz iste!   (Pogledaj kako to radim!!)

for otisak in $otisci; do                                                       # iteracija kroz datoteke prefiksa 'otisak' ..
    hash1=$(cat "$otisak")                                                      # hash1 - (Sa drugim $ referenciraj 'otisak') / Sa tako "$otisak" - spremi tekst za komandu 'cat' / Sve to neka sa prvim $ referencira hash1
    salt=$(echo "$hash1" | cut -d '$' -f 3)                                     # hash1 je sada tekstualni sadrzaj datoteke 'otisak*.dec'!! Odatle ces izvuci 'salt'!! Izvucemo salt!!
    
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



# Znaci, u 'hash1' smo pohranili sadrzaj odabrane-datoteke 'otisak' kako bi iz istog mogli izvuci 'salt'!

