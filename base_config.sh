#!/bin/bash

# $1 nom machine
# $2 id carte reseau
# $3 @ IP
# $4  @ passrelle
# $5 @ DNS


# Verification parametres
echo "-----------verififcation parametres------------"
if [ $# -ne 5 ]
then
        echo "le nombre de parametre !=5 "
        exit 1
fi
echo -e "-------------------------------------------------\n"
# Nom de la machine

echo "-------------changement Hostname--------------"
if  echo $1 > /etc/hostname
then
        host=$(cat /etc/hostname)
        echo "nom machine:" $host
else
        echo "erreur"
        exit 1
fi
echo -e  "---------------------------------------------------\n"

#Verification existance  carte reseau

echo "-----------Verification carte Reseau---------------- "
#lshw -class network -short | grep $2

if lshw -class network -short | grep $2
then
        echo "interface existe"
else
        echo "interface n'existe pas"
        exit 1
fi
echo -e  "----------------------------------------------------\n"

# desactivation carte reseau

echo "----------desactivation carte reseau-----------------------"

if ip link set dev $2 down
then
        echo "carte desactive...."
else
        echo "Erreur desactivation interface"
        exit 1
fi
echo -e  "----------------------------------------------------\n"

#Config Carte reseau
echo "----------Config carte reseau-----------------------"

cat  << EOF >> /etc/netplan/50-cloud-init.yaml
        $2:
            addresses: [$3]
            gateway4: $4
            nameservers:
                addresses: [$5]
            optional: true
EOF

if [ $? -ne 0 ]
then
        echo "erreur config  carte"
        exit 1
else
        echo "carte bien configure..."
fi
echo -e  "----------------------------------------------------\n"


# activation carte reseau

echo "----------activation carte reseau-----------------------"

if netplan apply
then
        echo " carte activer et configurer ...."
else
        echo "Erreur activation interface"
        exit 1
fi
echo -e  "----------------------------------------------------\n"

# Config DNS
echo "----------Config DNS---------------------------------"

sudo cat  << EOF > /etc/resolv.conf
nameserver $5
EOF

#echo nameserver $5 > /etc/resolv.conf

#echo nameserver $5 > /etc/resolvconf/resolv.conf.d/base

#echo resolveconf -u
if [ $? -ne 0 ]
then
        echo "erreur config  DNS"
        exit 1
else
        dns=$(dig | grep SERVER)
        echo "DNS  bien configure ["$dns"]"
fi

echo -e  "----------------------------------------------------\n"


echo "----------Test Verification Reseau -------------------------------"

ping -I $2 -c2  8.8.8.8

echo -e  "----------------------------------------------------\n"








