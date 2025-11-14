#!/bin/bash

# 8. GENERISANJE NOVIH KLJUČEVA I CSR (Čuvamo u 07/)
cd 07
openssl genrsa -out novi2048.key 2048
openssl genrsa -out novi4096.key 4096
openssl req -new -key novi2048.key -out novi1.csr -config ../02/openssl.cnf
openssl req -new -key novi4096.key -out novi2.csr -config ../02/openssl.cnf
cd ..

# 9. POTPISIVANJE NOVIH CSR (CA radi iz 02/, output u 08/)
cd 02
# NAPOMENA: Rucna modifikacija openssl.cnf pre ovoga je ključna (basicConstraints i keyUsage/extendedKeyUsage)
openssl ca -in ../07/novi1.csr -config openssl.cnf -days 5 -out ../08/novi1.pem
openssl ca -in ../07/novi2.csr -config openssl.cnf -days 5 -out ../08/novi2.pem
cd ..

# 10. VERIFIKACIJA NOVIH SERTIFIKATA
echo "I'm here ..'"
openssl verify -CAfile 02/rootca.pem -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -verbose 08/novi2.pem
openssl verify -CAfile 02/rootca.pem -purpose sslserver -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -purpose sslclient -verbose 08/novi1.pem
openssl verify -CAfile 02/rootca.pem -purpose sslserver -verbose 08/novi2.pem
openssl verify -CAfile 02/rootca.pem -purpose sslclient -verbose 08/novi2.pem
