#!/bin/bash

# --- KORAK 1: PRONALAZENJE KLJUCA ---

echo "--- 1. Pretraga ispravnog kljuca ---"
# Ekstrahovanje privatnog kljuca iz P12 i dešifrovanje (koristimo 'sigurnost')
# Zatim ekstrahovanje modula za poredjenje
openssl pkcs12 -in cert.p12 -nocerts -nodes -password pass:sigurnost | \
openssl rsa -modulus -noout > p12_modulus.txt

# Postavljanje CA fajlova
CERT_TO_REVOKE_1="clientcert_A.pem" # Imena sertifikata za opoziv, pretpostavljamo da su dostupni
CERT_TO_REVOKE_2="clientcert_B.pem"

FOUND_KEY=""

for k in kljuc*.key; do
    # Ekstrahovanje modula iz trenutnog kljuca
    kljuc_modulus=$(openssl rsa -in "$k" -modulus -noout 2>/dev/null)

    # Poredjenje sa modulusom iz P12
    if grep -q "$kljuc_modulus" p12_modulus.txt; then
        FOUND_KEY="$k"
        echo "✅ Ispravan kljuc je pronadjen: $FOUND_KEY"
        break
    fi
done

if [ -z "$FOUND_KEY" ]; then
    echo "❌ Kljuc nije pronadjen. Prekid."
    exit 1
fi

# Cleanup
rm p12_modulus.txt

# --- KORAK 2: PRIPREMA ZA CA (PRETPOSVLJENO) ---

# Pretpostavlja se da je CA sertifikat (CAcert.pem) kreiran i inicijalizovan (npr. iz zadatka 6)
# Pretpostavlja se postojanje ca.cnf, index.txt i serial fajlova.

CA_KEY="$FOUND_KEY" # Koristi pronadjeni kljuc
CA_CERT="CAcert.pem" # Pretpostavljeno CA ime
CA_CNF="ca.cnf"      # Pretpostavljeni config fajl iz Zadatka 6
INDEX_FILE="index.txt"
SERIAL_FILE="serial"

# Inicijalizacija baze podataka (ako nije vec uradjena od Zadatka 6)
touch "$INDEX_FILE"
echo 01 > "$SERIAL_FILE"
echo "--- CA Baza podataka inicijalizovana ---"

# --- KORAK 3: UPRAVLJANJE CRL LISTAMA ---

echo "--- 3. Generisanje CRL lista ---"

# 3.1 Opoziv (Revocation) za Prvu CRL Listu

# Opoziv 1: Suspendovan (certificateHold)
echo "Opoziv sertifikata 1 (Suspenzija)"
openssl ca -config "$CA_CNF" -keyfile "$CA_KEY" -cert "$CA_CERT" \
    -revoke "$CERT_TO_REVOKE_1" -crl_reason certificateHold -batch

# Opoziv 2: Prestanak rada (cessationOfOperation)
echo "Opoziv sertifikata 2 (Prestanak rada)"
openssl ca -config "$CA_CNF" -keyfile "$CA_KEY" -cert "$CA_CERT" \
    -revoke "$CERT_TO_REVOKE_2" -crl_reason cessationOfOperation -batch

# Generisanje PRVE CRL liste
echo "Generisanje prve CRL liste: crl1.pem"
openssl ca -config "$CA_CNF" -keyfile "$CA_KEY" -cert "$CA_CERT" \
    -gencrl -out crl1.pem

# 3.2 Opoziv (Revocation) za Drugu CRL Listu

# Vracanje Prvog sertifikata iz suspenzije (Un-revocation)
echo "Vracanje sertifikata 1 iz suspenzije (Undoing certificateHold)"
openssl ca -config "$CA_CNF" -keyfile "$CA_KEY" -cert "$CA_CERT" \
    -crl_hold off -revoke "$CERT_TO_REVOKE_1" -batch

# Napomena: Sertifikat 2 ostaje opozvan (cessationOfOperation je trajni opoziv)

# Generisanje DRUGE CRL liste
echo "Generisanje druge CRL liste: crl2.pem"
openssl ca -config "$CA_CNF" -keyfile "$CA_KEY" -cert "$CA_CERT" \
    -gencrl -out crl2.pem

echo "--- Završeno. Proverite crl1.pem i crl2.pem ---"