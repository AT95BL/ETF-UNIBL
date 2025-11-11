#!/bin/bash

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
