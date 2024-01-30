#!/bin/bash
#Purpose: Automate Certificate CSR Process
#Created by: Sunil Basnet
#Date: January 16, 2024
rm *.txt 2>/dev/null
rm *.cnf 2>/dev/null
clear
echo ""
echo " SAN Certificate Signing Request (CSR) Creation"
echo "==================================================="
echo ""
cp ./templates/dnstemp.cnf .
sed -e 's/cn_name/'$cn_name'/g' dnstemp.cnf > pre_sslconf.cnf
echo "Removing whitespaces\blank lines from file...."
echo ""
#remove blank lines from the file
echo "$list" > list.txt
cat list.txt | sed -e '/^$/d' > input1.txt
#remove blank spaces from the file
sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' input1.txt > input.txt
mv input.txt list.txt 2>/dev/null
rm input1.txt 2>/dev/null
echo "Checking duplicate SAN name line...."
echo ""
dupvalue=$(sort list.txt | uniq -d)
if [ ! -z "$dupvalue" ]; then
echo ""
echo "There is duplicate SAN on the list.txt"
echo ""
echo "$dupvalue"
echo ""
echo "Removing duplicate SAN name from list.txt..."
sort -u list.txt > list1.txt
mv list1.txt list.txt
echo ""
echo "Duplicate SAN name removal completed ..."
fi
echo ""
cat -n list.txt
echo ""
#formating list.txt DNS Number
num=1
for each in `cat list.txt`
do
echo $each
echo "DNS.$num = $each" >> newlist.txt
((num=num+1))
done
cat pre_sslconf.cnf newlist.txt > sslconf.cnf
echo ""
cat sslconf.cnf
echo ""
echo "CSR Generation started....."
echo ""
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out server.csr -subj "/C=US/ST=GA/L=Columbus/O=TSYS/OU=DigitalInnovation/CN=$cn_name" -config sslconf.cnf
echo ""
ls -lrt server.csr key.pem sslconf.cnf
echo ""
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
echo "SSL CSR Generation Completed"
echo ""
