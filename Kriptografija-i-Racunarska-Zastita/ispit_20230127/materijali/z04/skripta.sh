#!/bin/bash

# Učitava sve heširane otiske iz datoteke 'otisci.dec' u promenljivu 'otisci'.
# Zbog Word Splittinga, ova promenljiva će se u petlji automatski podeliti na pojedinačne heš stringove.
otisci=$(cat "otisci.dec")
ulazi="ulaz*.txt"

# Preimenovana varijabla: "otisak" je sada "hash1" da bi se naglasilo da sadrži heš string.
for hash1 in $otisci; do
    
    # ISPRAVLJENO: Uklonjen je pogrešan poziv 'hash1=$(cat "$otisak")'.
    # Varijabla $hash1 već sadrži heš string (npr. "$apr1$salt$hash_value").

    # Izvlačenje algoritma i salta direktno iz heš stringa ($hash1).
    algoritam=$(echo "$hash1" | cut -d '$' -f 2)
    salt=$(echo "$hash1" | cut -d '$' -f 3)
    
    for ulaz in $ulazi; do
        sadrzaj=$(cat "$ulaz")
        
        # Generisanje uporednog heša (hash2). Prebačeno na bolju $(...) sintaksu.
        hash2=$(openssl passwd -"$algoritam" -salt "$salt" "$sadrzaj" 2>error1.txt)
        
        if [ "$hash1" == "$hash2" ]; then
            echo -e "Algoritam: $algoritam"
            echo -e "Otisak: $hash1"  # Ispisujemo sam heš string
            echo -e "Ulaz: $ulaz" 
            break 
        fi
    done
done
