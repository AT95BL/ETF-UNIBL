#!/bin/bash

for dat in client*
do
    openssl pkcs12 -in $dat -out ca.crt -cacerts -nokeys -passin pass:sigurnost -passout pass:sigurnost 2>error.txt
    
    sad=$(openssl verify -CAfile ca.crt s1.crt 2>error2.txt)
    #echo $dat $sad
    #echo .
    if [[ "$sad" =~ "OK" ]]
    then
        echo $dat $sad
        break
    fi
done

# client6.p12 s1.crt: OK
# komanda je openssl verify -CAfile ca.crt s1.crt 
#gdje je ca.crt izvuceni cert iz p12 za client6.p12 tad se breaka i on ostaje taj
