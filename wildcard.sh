#!/bin/bash
#Purpose: Automate Certificate CSR Process
#Created by: Sunil Basnet
#Date: January 16, 2024
rm *.txt 2>/dev/null
rm *.cnf 2>/dev/null
clear
echo ""
echo " Wildcard Certificate Signing Request (CSR) Creation"
echo "==================================================="
echo ""
cp ./templates/wildtemp.cnf .
sed -e 's/cn_name/'$cn_name'/g' wildtemp.cnf > sslconf.cnf
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out server.csr -subj "/C=US/ST=GA/L=Columbus/O=TSYS/OU=DigitalInnovation/CN=$cn_name" -config sslconf.cnf
echo ""
ls -lrt *.csr key.pem sslconf.cnf
echo "sslconf.cnf"
cat sslconf.cnf
echo ""
echo "key.pem"
echo ""
cat key.pem
echo ""
echo "server.csr"
cat server.csr
echo ""
echo "Wildcard Cert CSR Creation Completed ......"
echo ""
