#!/bin/bash

otisci=$(cat "otisci.dec")
ulazi="ulaz*.txt"

for hash1 in $otisci; do # U pratećim materijalima date su ulazne datoteke i --datoteka sa otiscima--
    
    # Izvlačenje algoritma i salta direktno iz heš stringa ($hash1).
    algoritam=$(echo "$hash1" | cut -d '$' -f 2)    # Zapamti, iz otiska se može izvući i algoritam!!
    salt=$(echo "$hash1" | cut -d '$' -f 3)         # Zapamti, iz otiska se može izvući i salt!!
    
    for ulaz in $ulazi; do
        sadrzaj=$(cat "$ulaz")
        
        hash2=$(openssl passwd -"$algoritam" -salt "$salt" "$sadrzaj" 2>error1.txt)
        
        if [ "$hash1" == "$hash2" ]; then
            echo -e "Algoritam: $algoritam"
            echo -e "Otisak: $hash1"  # Ispisujemo sam heš string
            echo -e "Ulaz: $ulaz" 
            break 
        fi
    done
done

