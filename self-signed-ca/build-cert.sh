#!/bin/bash
# based on https://datacenteroverlords.com/2012/03/01/creating-your-own-ssl-certificate-authority/

clear

echo -e "Persiapan bikin root CA cert."
bash create-rootca.sh
echo -e ".. done!\n"
echo -e "Persiapan bikin self signed cert.."
bash create-selfsignedcerts.sh
echo -e ".. done!\n"

echo -e "Tambahkan file rootCA.pem ke chrome.."
echo -e "Tambahkan /etc/hosts untuk domain yang masuk dalam san ke 127.0.0.1"
