#/bin/bash

envs="env*"             # Jer, envelope su datoteke ..
keys="kljuc*"           # imamo kljuceve, odma znam da jednom petljom, gornjom for petljom prolazim kroz envelope, a drugom-unutrasnjom for petljom prolazim kroz kljuceve ..

for env in $envs
do
	for key in $keys
	do
		r=$(openssl pkeyutl -decrypt -in $env -inkey $key 2>error.txt)  # rsautl was ..use pkeyutl instead 
		if [[ "$r" != "" ]] then
			openssl enc -camellia-128-cfb -d -in sifrat.dec -key 
		fi
	done
done

#Bravo, nasli ste rjesenje :).
