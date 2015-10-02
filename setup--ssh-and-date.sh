#!/bin/bash

YOUR_USER=""
BEAGLE_IP="192.168.7.2"
YOUR_PUB_KEY="id_rsa.pub"

# ASK laptop client  user name
if [ "${YOUR_USER}" == "" ]
then
    echo "insert your laptop user"
    read -r YOUR_USER
fi

# REMOVE old host key
ssh-keygen -R ${BEAGLE_IP}

# COPY public key to beagle
ssh-copy-id -i ~/.ssh/${YOUR_PUB_KEY} root@${BEAGLE_IP}

# GET local date
# ansible -i ../ansible_hosts localhost -a "date"

# SET beagle date
NEW_DATE=$(date | awk '{print $3,$2,$6,$4}')
ssh root@${BEAGLE_IP} "date --set='$NEW_DATE'"
