
otisci="otisak*.dec"
lozinke="lozinka*.txt"

for otisak in $otisci; do 
   
   hash1=$(cat "$otisak")
   salt=$(echo "$hash1" | cut -d '$' -f 3)
   koristenAlgoritam=$(echo "$hash1" | cut -d '$' -f 2)

   for lozinka in $lozinke; do 
        sadrzajDatoteke=$(cat $lozinka)
        hash2=$(openssl passwd -"$koristenAlgoritam" -salt "$salt" "$sadrzajDatoteke")
        if [ "$hash1" == "$hash2" ]; then
            echo -e "Otisak: $otisak"
            echo -e "Sadrzaj: $sadrzajDatoteke"
            break
        fi
    done
done

algoritmi=$(openssl enc -list | grep "aes-256")                                 #   (NAUCI KOMANDU!!)

lozinka1=$(cat lozinka30.txt)
lozinka2=$(cat lozinka3.txt)
lozinka3=$(cat lozinka18.txt)

for algoritam in $algoritmi
do
    
    openssl enc $algoritam -d -in sifrat.dec -out sifrat2.dec -k "$lozinka1" 2>error1.txt
    openssl enc $algoritam -d -in sifrat2.dec -out sifrat3.dec -k "$lozinka2" 2>error2.txt
    openssl enc $algoritam -d -in sifrat3.dec -out ulaz.dec -k "$lozinka3" 2>error3.txt
    cat ulaz.dec
    
done