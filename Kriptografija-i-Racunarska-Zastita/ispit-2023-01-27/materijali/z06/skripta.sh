#!/bin/bash

keystores="keystore*"

for keystore in $keystores
do
    res=`keytool -list -v -keystore $keystore -storepass sigurnost 2>error1.txt`
    if [[ "$res" =~ "serverAuth" ]]
        then
            echo -e "Keystore: $keystore"
            break
    fi
done
#Keystore: keystore22.jks

