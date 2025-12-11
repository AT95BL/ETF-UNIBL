#/bin/bash

ulazi="ulaz*"

for ulaz in $ulazi
do
	openssl enc -base64 -d -in $ulaz -out base$ulaz
	alg=`cat base$ulaz | cut -d '$' -f 2`
	salt=`cat base$ulaz | cut -d '$' -f 3`

	r=`openssl passwd -$alg -salt $salt $ulaz 2>error.txt`
	sadrzaj=`cat base$ulaz`
	if [[ "$r" == "$sadrzaj" ]] then
		echo $ulaz
	fi
done

#ulaz38.txt
