#!/bin/bash

# Prethodno - manualno kreiraj direktorijum '02' i u njega smjesti 'openssl.cnf'
mkdir -p 01 02 03 04 05 06 07 08 09 10

#   1
openssl genrsa -out 01/private2048.key 2048
openssl genrsa -out 01/private4096.key -aes128 4096 # trazice password:sigurnost - eksplicitno je naveden i sam algoritam ..

#   2
#   Napomena1: slijedi niz komandi koje predstavljaju kostur
#   Napomena2: kopiraj openssl.cnf datoteku u direktorijum 02
cd 02
mkdir -p newcerts certs crl requests private
# mkdir certs
touch index.txt
echo "05" > serial
# mkdir crl
echo "01" > crlnumber
# mkdir requests
# mkdir private
cp ../01/* private/
cd ..                       # Vrati se nazad na root direktorijum! Prethodno si sa 'cd 02' presao u 02/

#   3
#   Datoteku 'openssl/cnf' si vec premjestio u /02 ..
#   Otvori istu i dobro obrati paznju na to sta je u njoj zakomentarisano!! -Po potrebi, izvrsi i modifikaciju!!
#   Prije izvrsavanja svake komande, pogledaj u datoteku, mozda je komanda vezana za neki od parametara datoteke!!

#   4
openssl req -x509 -new -key 02/private/private4096.key -out 03/rootca.pem -config 02/openssl.cnf                    # U openssl.cnf pogledaj certificate	= $dir/rootca.pem 	# The CA certificate
cp 03/rootca.pem 02/
openssl x509 -in 02/rootca.pem -noout -text

#   5
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req1.csr
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req2.csr
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req3.csr

#   6
openssl req -in 04/req1.csr -noout -text
openssl req -in 04/req2.csr -noout -text
openssl req -in 04/req3.csr -noout -text
openssl req -in 04/req1.csr -out 04/req1.der -inform PEM -outform DER
openssl req -in 04/req2.csr -out 04/req2.der -inform PEM -outform DER
openssl req -in 04/req3.csr -out 04/req3.der -inform PEM -outform DER

#   7
#   7
cd 02
echo "I'm here..'"
openssl ca -in ../04/req3.csr -out ../03/client3.pem -config ../02/openssl.cnf
openssl ca -in ../04/req2.csr -out ../03/client2.pem -config ../02/openssl.cnf
openssl ca -in ../04/req1.csr -out ../03/client1.pem -config ../02/openssl.cnf

openssl x509 -in ../03/client3.pem -noout -text
openssl x509 -in ../03/client2.pem -noout -text
openssl x509 -in ../03/client1.pem -noout -text
cd ..

