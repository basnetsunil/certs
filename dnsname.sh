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
printf "Please enter CN: "
read cn_name
echo ""
echo "You have entered: $cn_name"
echo ""
echo "Please confirm to enter or CTRL +C to cancel"
read input
#echo ""
cp ./templates/dnstemp.cnf .
sed -e 's/cn_name/'$cn_name'/g' dnstemp.cnf > pre_sslconf.cnf
#echo ""
echo "Please provide list of Subject Alternate Name (SAN) to generate csr file"
sleep 3
vim +star list.txt
echo ""
[ ! -s list.txt ]
if [ $? -eq 0 ]; then
echo "File is empty, please start over again"
exit 2
fi
echo "Removing whitespaces\blank lines from file...."
echo ""
#remove blank lines from the file
#sed -i '/^$/d' list.txt
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
echo "Please review list of SAN name that you like to include on Certificate...."
echo ""
sleep 2
cat -n list.txt
echo ""
echo "Either enter to continue or CTRL C to stop"
read
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
echo "Please review sslconf.cnf file"
echo ""
cat sslconf.cnf
echo ""
echo "Please hit ENTER continue or CTRL +C to cancel"
echo ""
read
echo "CSR Generation started....."
echo ""
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out server.csr -subj "/C=US/ST=GA/L=Columbus/O=TSYS/OU=DigitalInnovation/CN=$cn_name" -config sslconf.cnf
echo ""
ls -lrt server.csr key.pem sslconf.cnf
echo ""
echo "SSL CSR Generation Completed"
echo ""
