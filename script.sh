#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Error: No IPs file specified."
    echo
    echo "Usage: ./script.sh <IPs file> "
    exit 1
fi

DB_USER='root';
DB_PASSWD='thisisatest';

DB_NAME='ssldb';
DB_TABLE='ips';

ips=`cat $1`

for i in $ips;
	do prots=`nmap -sV --script ssl-enum-ciphers -p 443 $i | grep -i -o -E 'SSLv[2-3]|TLSv1.[0-3]' | tr -s ' ' | cut -d" " -f2 | cut -d":" -f1 | sort -u`;
	SSLv2=`echo $prots | grep SSLv2 | wc -l`;
	SSLv3=`echo $prots | grep SSLv3 | wc -l`;
	TLSv10=`echo $prots | grep "TLSv1.0" | wc -l`;
	TLSv11=`echo $prots | grep "TLSv1.1" | wc -l`;
	TLSv12=`echo $prots | grep "TLSv1.2" | wc -l`;
	TLSv13=`echo $prots | grep "TLSv1.3" | wc -l`;
	query="INSERT INTO $DB_TABLE (ip, puerto, SSLv2, SSLv3, TLSv10, TLSv11, TLSv12, TLSv13, Fecha) VALUES ('$i', '43', '$SSLv2', '$SSLv3', '$TLSv10', '$TLSv11', '$TLSv12', '$TLSv13',  UNIX_TIMESTAMP ())";
	mysql -u root -pthisisatest ssldb -e "$query"

	prots=`nmap -sV --script ssl-enum-ciphers -p 8443 $i | grep -i -o -E 'SSLv[2-3]|TLSv1.[0-3]' | tr -s ' ' | cut -d" " -f2 | cut -d":" -f1 | sort -u`;
	SSLv2=`echo $prots | grep SSLv2 | wc -l`;
	SSLv3=`echo $prots | grep SSLv3 | wc -l`;
	TLSv10=`echo $prots | grep "TLSv1.0" | wc -l`;
	TLSv11=`echo $prots | grep "TLSv1.1" | wc -l`;
	TLSv12=`echo $prots | grep "TLSv1.2" | wc -l`;
	TLSv13=`echo $prots | grep "TLSv1.3" | wc -l`;
	query="INSERT INTO $DB_TABLE (ip, puerto, SSLv2, SSLv3, TLSv10, TLSv11, TLSv12, TLSv13, Fecha) VALUES ('$i', '8443', '$SSLv2', '$SSLv3', '$TLSv10', '$TLSv11', '$TLSv12', '$TLSv13',  UNIX_TIMESTAMP ())";
	mysql -u root -pthisisatest ssldb -e "$query";

done
