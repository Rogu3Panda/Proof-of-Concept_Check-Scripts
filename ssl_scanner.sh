#!/bin/bash
options_found=0
echo ""
echo "SSL Check Script"
echo "Version 1.0.0"
echo "Written by Rogu3Panda"
echo ""
echo "Script Purpose: Scans for all SSL Ciphers including TLS1.1, TLS1.0, SSLv3, SSLv2"
echo ""
echo "Option: -h Help Interface"
echo "Option: -t <target file>"
echo "Option: -o <Output file>"
echo "Option: -p <port>, if not specified, script will default to 443"

while getopts ":ht:o:p:pL:" opt;do

  options_found=1

    case $opt in
	t)
	  TARGET_FILE=${OPTARG}
	    if [ ${TARGET_FILE: -4} != ".txt" ];then
		echo "[*] Error: Please enter in a file containing targets with a .txt extension"
			exit 1
	    fi
	    ;;
         o)
           OUTPUT_FILE=${OPTARG}
           if [ ${OUTPUT_FILE: -4} != ".txt" ];then
             echo "[*] ERROR: Please enter in a output file"
             exit 1
           fi
           ;;
         p)
           PORT=${OPTARG}
           ;;
	h)
	  echo "Help Command"
	  echo "Usage: ./ssl_scanner.sh [options]"
	  echo "Options:"
	  echo "-t <Target_File.txt>"
	  echo "-o <Output_File.txt>"
	  echo "-p <Port_Number>"
	  exit 1
	  ;;
    esac
done

if ((!options_found));then
	echo ""
	echo "Please enter in the appropriate optoins"
	exit 0
fi
clear
for IP in $(cat $TARGET_FILE);do
	echo "Checking for Weak Cipher Suites on: $IP:$PORT" 2>&1 | tee -a $OUTPUT_FILE
	sslscan --no-failed $IP:$PORT 2>&1 | tee -a $OUTPUT_FILE
done
exit 0
