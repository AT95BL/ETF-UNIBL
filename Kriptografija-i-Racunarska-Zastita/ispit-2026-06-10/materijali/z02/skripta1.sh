#!/bin/bash

sifrati=sifrat*.txt

for sifrat in $sifrati; do 

    res=$(openssl dgst -verify public.key -sha384 -signature potpis.txt $sifrat 2>error.txt)

    if [[ "$res" =~ "OK" ]]; then
        echo "$sifrat"
    fi

done

#   sifrat91.txt
#   Slijedi dekripcija

openssl enc -d -in sifrat91.txt -out odgovor.txt -aria-256-cbc -k sigurnost

#   U pratećim materijalima je dat niz šifrata dobijenih kriptovanjem nepoznate ulazne datoteke ARIA algoritmom u CBC načinu rada. 
#   - znači li to da je neko, 
#   iskoristio simetričnu kriptografiju nad datotekom i uradio njenu enkripciju upotrebom pomenutog algoritma?
#   -- ZNAČI! Rješenje ćeš naći tako što ćeš pronaći datoteku i izvršiti njenu dekripciju upotrebom pomenutog algoritma!
#
#   Odrediti sadržaj ulazne datoteke ako je za kriptovanje korišten ključ sigurnost. 
#   -- Upravo onako kako je prethodno opisano..
#
#   U materijalima je dat i potpis tražene datoteke sa šifratom, dobijene pomoću RSA algoritma i SHA-384 hash funkcije. 
#   Dat je i ključ kojim je moguće verifikovati potpis.
#   --  Znači da je neko uradio sljedeće, uzeo je datoteku i istu provukao kroz HASH funkciju upotrebom SHA-384 algoritma
#       kako bi dobio njen otisak.
#       Uzeo je onda taj otisak, iskoristio svoj privatni RSA generisani ključ i potpisao taj otisak,
#       tebi je poslao svoj javni ključ kako bi ti na osnovu njega mogao da "provališ" koju je to datoteku
#       potpisao i na kraju onda da uradiš dekripciju te datoteke!!

#   openssl dgst - pozivamo osnovni OpenSSL alat za rad sa heš(digest) funkcijama!

#   -verify public.key - govorimo OpenSSL-u da ne generiše novi otisak,
#       već da VERIFIKUJE postojeći potpis!
#       Za tu akciju mu prosljeđujemo javni ključ pošiljaoca (public.key) kako bi mogao dešifrovati digitalni potpis.

#   -sha384 je heš algoritam koji je originalno korišćen

#   -signature potpis.txt   prosljeđujemo fajl koji sadrži sam digitalni potpis..

#   $sifrat je datoteka koja se testira