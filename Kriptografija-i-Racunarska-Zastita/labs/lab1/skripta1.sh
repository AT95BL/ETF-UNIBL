#!/bin/bash

for i in {1..10}; do
    echo "Pozdrav$i" > ulaz$i.txt
done

for i in {1..10}; do
    echo "Sadrzaj datoteke ulaz$i.txt: "
    cat ulaz$i.txt
done

for i in {1..10}; do
    echo "Enkripcija ulaz$i.txt .."
    openssl des3 -in ulaz$i.txt -out izlaz$i.txt -k sigurnost
done

for i in {1..10}; do
    echo "Dekripcija izlaz$i.txt .."
    openssl des3 -d -in izlaz$i.txt -out izlazDekriptovano$i.txt -k sigurnost
done

for i in {1..10}; do
 echo "Sadrzaj datoteke izlazDekriptovano$i.txt: "
 cat izlaz$iDekriptovano.txt
done

for i in {1..10}; do
   echo "Base64 enkodovanje datoteke ulaz$i.txt .."
   openssl enc -base64 -in ulaz$i.txt -out izlazBase64$i.txt 
done

for i in {1..10}; do
    echo "Base64 dekodovanje datoteke izlaz$iBase64.txt"
    openssl enc -d base64 -in izlazBase64$i.txt -out izlazBase64Dekodovano$i.txt
done


