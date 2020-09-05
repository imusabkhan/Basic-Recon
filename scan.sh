#!/bin/bash

input=$1

masscan_scan() {
mkdir -p ip tmp nmap
masscan -iL $input -p 0-65535 --rate=10000 --open -oG tmp/test.txt
}
masscan_scan

filter_ip () {
cat tmp/test.txt | grep "Host" | awk '{print $2}' | sort -u > tmp/tmp.txt
}
filter_ip

nmap_file() {
for ip in $(cat tmp/tmp.txt);
do
        echo "nmap $ip -T3 -sV -oX nmap/$ip.xml -p" > ip/tmp.txt
        cat tmp/test.txt | grep "Host" | awk '{print $2,$5}' | sed 's/[open/tcp]//g' | grep "$ip" | awk '{print $2}' | xargs | sed 's/ /,/g' |  sort -u >> ip/tmp.txt
        cat ip/tmp.txt | xargs > ip/$ip
        rm ip/tmp.txt 
done
}
nmap_file

nmap_scan() {
for ip in $(ls ip/*);
do
	sleep 2
	$(cat $ip)

done
}
nmap_scan

remove_file () {

rm ip tmp -R
}
remove_file
