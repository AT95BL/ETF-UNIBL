#/bin/bash

ulazi="ulaz*"
otisak=$(cat "otisak.dec")
echo $otisak
for ulaz in $ulazi
do
	r=$(openssl dgst -sha3-384 $ulaz | cut -d ' ' -f 2)
	r1=$(openssl dgst -sha384 $ulaz | cut -d ' ' -f 2)
	
	if [[ "$r" == "$otisak" || "$r1" == "$otisak" ]] then
		echo $ulaz
	fi
done

#ulaz38.txt
