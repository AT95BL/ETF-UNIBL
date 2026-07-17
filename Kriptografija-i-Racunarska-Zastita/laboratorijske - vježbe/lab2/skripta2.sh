#!/bin/bash

# 1
echo "Generisanje para kljuceva upotrebom 3DES algoritma.."
openssl genrsa -out des-private-pem.key -des3 2048
openssl rsa -in des-private-pem.key -out des-private-der.key -inform PEM -outform DER

# 2
echo "Generisanje para kljuceva upotrebom AES-128 algoritma.."
openssl genrsa -out aes-private-pem.key -aes128 2048
openssl rsa -in aes-private-pem.key -out aes-private-der.key -inform PEM -outform DER

# 3
echo "Prikaz informacija o svim generisanim kljucevima.."
openssl rsa -in des-private-der.key -noout -text
openssl rsa -in aes-private-der.key -noout -text

# 4
echo "Izdvajanje javnih kljuceva iz datoteka koje sadrze parove kljuceva u PEM formatu .."
openssl rsa -in des-private-pem.key -pubout -out des-public-pem.key
openssl rsa -in aes-private-pem.key -pubout -out aes-public-pem.key

# 5
echo "Informacije o izdvojenim javnim kljucevima .."
openssl rsa -in des-public-pem.key -pubin -noout -text
openssl rsa -in aes-public-pem.key -pubin -noout -text

# 6 (ISPRAVLJENO: Dodano -pubout)
echo "Konverzija javnih kljuceva iz PEM formata u DER format .."
openssl rsa -in des-public-pem.key -pubin -out des-public-der.key -pubout -inform PEM -outform DER
openssl rsa -in aes-public-pem.key -pubin -out aes-public-der.key -pubout -inform PEM -outform DER

# 7 (ISPRAVLJENO: Koristi JAVNI ključ za šifrovanje - aes-public-pem.key)
echo "Datoteka za ekripciju i slanje (Sifra JAVNIM kljucem).."
echo "trustnoone.." > datoteka-clear.txt
openssl pkeyutl -encrypt -pubin -inkey aes-public-pem.key -in datoteka-clear.txt -out datoteka-enc.txt

# 8 (ISPRAVLJENO: Koristi PRIVATNI ključ za dešifrovanje - aes-private-pem.key)
echo "Datoteka za dekripciju (Desifra PRIVATNIM kljucem).."
openssl pkeyutl -decrypt -in datoteka-enc.txt -out datoteka-decr.txt -inkey aes-private-pem.key

# 9 (ISPRAVLJENO, Koristeći isključivo simetrično šifrovanje sa lozinkom "sigurnost")
echo "Poslednji zadatak - Simetrično šifrovanje sa lozinkom iz komandne linije"

# Priprema datoteke
echo "itsasecret" > datoteka1-clear.txt

# Simetrično šifrovanje datoteke (Koristi se lozinka "sigurnost")
openssl enc -in datoteka1-clear.txt -out datoteka1-enc.txt -aes-192-ofb -k "sigurnost"

# Simetrično dešifrovanje datoteke (Koristi se lozinka "sigurnost")
openssl enc -d -in datoteka1-enc.txt -out datoteka1-decr.txt -aes-192-ofb -k "sigurnost"

