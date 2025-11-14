#!/bin/bash

# 11
openssl ca -revoke ../08/novi1.pem -config ../02/openssl.cnf -crl_reason keyCompromise
openssl ca -gencrl -out ../02/crl/rootcrl.pem -config ../02/openssl.cnf
openssl crl -in ../02/crl/rootcrl.pem -noout -text

# 12
openssl pkcs12 -export -inkey ../07/novi2048.key -in ../08/novi1.pem -certfile ../02/rootca.pem -out novi.p12

# 13
openssl verify -CAfile ThawteSGCCA mail.google.com
openssl verify el.etfbl.net

# 14
openssl crl -in pca1.1.1.crl -noout -text -inform DER
