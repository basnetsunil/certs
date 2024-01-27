#!/bin/bash
#Purpose: Automate Certificate CSR Process
#Created by: Sunil Basnet
#Date: January 16, 2024
clear
echo ""
echo " Wildcard Certificate Signing Request (CSR) Creation"
echo "==================================================="
echo ""
printf "Please enter CN: "
read cn_name
echo ""
echo "You have entered: $cn_name"
echo ""
echo "Please confirm to enter or CTRL +C to cancel"
read input
echo ""
cp ./templates/wildtemp.cnf .
sed -e 's/cn_name/'$cn_name'/g' wildtemp.cnf > sslconf.cnf
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out server.csr -subj "/C=US/ST=GA/L=Columbus/O=TSYS/OU=DigitalInnovation/CN=$cn_name" -config sslconf.cnf
ls -lrt
