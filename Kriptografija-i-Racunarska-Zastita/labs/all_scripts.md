--------------------------------------------------------------------------------------------------
# Uputstvo za korištenje OpenSSL alata - simetrični algoritmi, kodovanje

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
-------------------------------------------------------------------------------------------------------------

# Laboratorijska vježba 2 – asimetrični algoritmi, digitalna envelopa

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
-----------------------------------------------------------------------------------------------------------------------------------------------

# Laboratorijska vježba 3 – heš funkcije i integritet poruka

# 1
password="password"
echo "Your Current Password is: ${password} .."

echo "Command 'passwd ${password}' results: "
openssl passwd ${password}
echo "Command 'passwd -salt an ${password}' results:"
openssl passwd -salt an ${password}

echo "Command 'passwd -1 ${password}' results: "
openssl passwd -1 ${password}
echo "Command 'passwd -1 -salt 600ax4QC ${password}' results: "
openssl passwd -1 -salt 600ax4QC ${password}

echo "Command 'passwd -apr1 ${password}' results: "
openssl passwd -apr1 ${password}
echo "Command 'passwd -apr1 -salt crpOIWxa ${password}' results: "
openssl passwd -apr1 -salt crp0IWxa ${password}

echo ""
echo ""


# 2 
algorithms=("-a" "-1" "") 
algorithm_names=("Blowfish(bcrypt)" "MD5(APR1)" "Default(DES)")
password_count=7
salts=("2y7lq56T" "2r9shAE7" "J/TxtoUa" "Zr/qXy1")

# Petlja 1: Iteracija kroz sve lozinke (lozinka1 do lozinka7)
for i in $(seq 1 $password_count); do

    lozinka="lozinka$i"
    
    echo -e "\n--- LOZINKA: ${lozinka} ---"
    
    # Petlja 2: Iteracija kroz sve algoritme
    for alg_index in ${!algorithms[@]}; do

        alg=${algorithms[$alg_index]}
        alg_name=${algorithm_names[$alg_index]}
        
        echo -e "\n  [Algoritam: ${alg_name} (${alg})] "

        # 2a. Slučaj: BEZ FIKSNOG SALT-A (Automatski generisan salt)
        echo "    > Bez fiksnog salt-a (nasumičan hash):"
        openssl passwd $alg ${lozinka}
        
        # Petlja 3: Iteracija kroz sve fiksne salt-ove
        for salt in ${salts[@]}; do
            
            # 2b. Slučaj: SA FIKSNIM SALT-OM
            echo "    > Sa salt-om (${salt}):"
            # Koristimo openssl passwd sa svim parametrima
            openssl passwd $alg -salt $salt ${lozinka}
            
        done
    done
done

# 3
echo "testna datoteka1" > test1
echo "testna datoteka2" > test2
openssl dgst -sha1 -out otisak1 test1                                                       #   openssl dgst –sha1 –out izlaz.txt ulaz.txt
cat otisak1
openssl dgst -sha1 -out otisak2 test2
cat otisak2

# 4
openssl dsaparam -out dsaparam2048.pem 2048                                                 #   openssl dsaparam –out dsaparam.pem 2048
openssl dsaparam -out dsaparam4096.pem 4096
openssl dsaparam -in dsaparam2048.pem -out dsaparam2048.der -inform PEM -outform DER
openssl dsaparam -in dsaparam4096.pem -out dsaparam4096.der -inform PEM -outform DER
openssl dsaparam -in dsaparam2048.pem -noout -text
openssl dsaparam -in dsaparam4096.pem -noout -text

# 5
openssl gendsa -out dsa-private2048.pem dsaparam2048.pem                                    #   openssl gendsa –out dsa-private.pem dsaparam.pem    
openssl gendsa -out dsa-private4096.pem -des3 dsaparam4096.pem
openssl dsa -in dsa-private2048.pem -out dsa-private4096.der -inform PEM -outform DER
openssl dsa -in dsa-private4096.pem -out dsa-private4096.der -inform PEM -outform DER
openssl dsa -in dsa-private2048.pem -noout -text
openssl dsa -in dsa-private4096.pem -noout -text

# 6
echo "sadrzaj" > datoteka
echo "sadrzaj2" > datoteka2
openssl dgst -sha1 -out datoteka.signed -sign dsa-private4096.pem datoteka
openssl dgst -sha1 -out datoteka.signed -sign dsa-private4096.pem datoteka2
openssl dsa -in dsa-private4096.pem -pubout -out dsa-public4096.pem
openssl dgst -sha1 -verify dsa-public4096.pem -signature datoteka.signed datoteka
openssl dgst -sha1 -verify dsa-public4096.pem -signature datoteka.signed datoteka2

-----------------------------------------------------------------------------------------------------------------------------------------------


# Laboratorijska vježba 4 - rad sa digitalnim sertifikatima

# Prethodno - manualno kreiraj direktorijum '02' i u njega smjesti 'openssl.cnf'
mkdir -p 01 02 03 04 05 06 07 08 09 10

#   1
echo "First Task .."
openssl genrsa -out 01/private2048.key 2048
openssl genrsa -out 01/private4096.key -aes128 4096 # trazice password:sigurnost - eksplicitno je naveden i sam algoritam ..

#   2
#   Napomena1: slijedi niz komandi koje predstavljaju kostur
#   Napomena2: kopiraj openssl.cnf datoteku u direktorijum 02
echo "Second Task .."
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
echo "Fourth Task .."
openssl req -x509 -new -key 02/private/private4096.key -out 03/rootca.pem -config 02/openssl.cnf                    # U openssl.cnf pogledaj certificate	= $dir/rootca.pem 	# The CA certificate
cp 03/rootca.pem 02/
openssl x509 -in 02/rootca.pem -noout -text

#   5
"Fifth Task .."
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req1.csr
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req2.csr
openssl req -new -key 01/private2048.key -config 02/openssl.cnf -out 04/req3.csr

#   6
echo "Sixth Task .."
openssl req -in 04/req1.csr -noout -text
openssl req -in 04/req2.csr -noout -text
openssl req -in 04/req3.csr -noout -text
openssl req -in 04/req1.csr -out 04/req1.der -inform PEM -outform DER
openssl req -in 04/req2.csr -out 04/req2.der -inform PEM -outform DER
openssl req -in 04/req3.csr -out 04/req3.der -inform PEM -outform DER

#   7
cd 02
echo "Seventh Task ..'"
openssl ca -in ../04/req3.csr -out ../03/client3.pem -config ../02/openssl.cnf
openssl ca -in ../04/req2.csr -out ../03/client2.pem -config ../02/openssl.cnf
openssl ca -in ../04/req1.csr -out ../03/client1.pem -config ../02/openssl.cnf

openssl x509 -in ../03/client3.pem -noout -text
openssl x509 -in ../03/client2.pem -noout -text
openssl x509 -in ../03/client1.pem -noout -text
cd ..

#!/bin/bash

# 8. GENERISANJE NOVIH KLJUČEVA I CSR (Čuvamo u 07/)
echo "Eighth Task .."
cd 07
openssl genrsa -out novi2048.key 2048
openssl genrsa -out novi4096.key 4096
openssl req -new -key novi2048.key -out novi1.csr -config ../02/openssl.cnf
openssl req -new -key novi4096.key -out novi2.csr -config ../02/openssl.cnf
cd ..

# 9. POTPISIVANJE NOVIH CSR (CA radi iz 02/, output u 08/)
echo "Ninth Task .."
cd 02
# NAPOMENA: Rucna modifikacija openssl.cnf pre ovoga je ključna (basicConstraints i keyUsage/extendedKeyUsage)
openssl ca -in ../07/novi1.csr -config openssl.cnf -days 5 -out ../08/novi1.pem
openssl ca -in ../07/novi2.csr -config openssl.cnf -days 5 -out ../08/novi2.pem
cd ..

# 10. VERIFIKACIJA NOVIH SERTIFIKATA
echo "Tenth Task'"
openssl verify -CAfile 02/rootca.pem -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -verbose 08/novi2.pem
openssl verify -CAfile 02/rootca.pem -purpose sslserver -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -purpose sslclient -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -purpose sslserver -verbose 08/novi2.pem
openssl verify -CAfile 02/rootca.pem -purpose sslclient -verbose 08/novi2.pem

#!/bin/bash

# 11
echo "Eleventh Task .."
cd 02
openssl ca -revoke ../08/novi1.pem -config openssl.cnf -crl_reason keyCompromise
openssl ca -gencrl -out ../02/crl/rootcrl.pem -config ../02/openssl.cnf
openssl crl -in ../02/crl/rootcrl.pem -noout -text
cd ..

# 12
echo "Final Task .."
openssl pkcs12 -export -inkey 07/novi2048.key -in 08/novi1.pem -certfile 02/rootca.pem -out novi.p12

# 13
# openssl verify -CAfile ThawteSGCCA mail.google.com
# openssl verify el.etfbl.net

# 14
# openssl crl -in pca1.1.1.crl -noout -text -inform DER
