#!/bin/bash

echo "-------------------------adresse IP-------------------------------"  >> /tmp/remote.txt
ssh superv@172.18.10.12 "ip addr show enp0s8 | grep 'inet' | cut -f2 | awk '{print $2}' " >> /tmp/rem$

echo "---------------------------Espace Disque -----------------------------" >> /tmp/remote.txt
ssh superv@172.18.10.12  " df -h | grep '/dev/sda' | awk '{print $4}' " >> /tmp/remote.txt

echo "---------------------------Charge CPU-----------------------------" >> /tmp/remote.txt
ssh  superv@172.18.10.12  " LA COMMANDE TOP ou UPTIME ….. " >> /tmp/remote.txt
