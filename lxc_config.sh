#!/bin/bash

#------------Verification Arguments----------------------------------------------------------------
if [ $# -ne 2 ]
then
        echo " Arguments manquants ! "
        echo "./creation_con.sh template nomMachine"
        exit 1
fi
#---------------------------------------------------------------------------------------------------
#--------------------- création du container--------------------------------------------------------
lxc-create -t download -n $2 -- -d $1 -r bionic -a amd64
if [ $? -ne 0 ]
then
        echo " la creation de container a echoue ! "
        exit 1
fi
echo "...........creation du container : ok................................. "
#--------------------------------------------------------------------------------------------------
#--------------------- configuration systeme----------------------------------------------------------
echo " demarrage de la machine ... "
lxc-start -n $2
if [ $? -ne 0 ]
then
        echo " erreur lors du demarrage de la machine ! "
        exit 1
fi
sleep 3
# --------------------------- CPU -------------------------------------------------------------------
lxc-cgroup -n $2 cpuset.cpus 0,1
if [ $? -ne 0 ]
then
        echo " l\'attribution des cpu  a echoue ! "
        exit 1
fi
echo " vous avez attribue cpu :"
lxc-attach -n $2 -- cat /proc/cpuinfo | grep processor
#-------------------------------------------------------------------------------------
#------------------- RAM--------------------------------------------------------------------
lxc-cgroup -n $2 memory.limit_in_bytes 268435456
if [ $? -ne 0 ]
then
        echo " erreur lors de la modification de la memoire allouee ! "
        exit 1
fi
echo "........................... demarrage ok !............................. "
echo " vous avez affecte en RAM :"
lxc-attach -n $2 -- cat /proc/meminfo | grep ^MemTotal
if [ $? -ne 0 ]
then
        echo " la verification de la memoire a echoue! "
        exit 1
fi
echo "...................------ Fin configuration systeme................. --- "

lxc-stop -n $2
if [ $? -ne 0 ]
then
        echo " Erreurss! "
        exit 1
fi
#------------------------------------------Configuration Reseau-------------------------------------------------------------
echo "lxc.net.0.type = phys" >> /var/lib/lxc/$2/config
echo "lxc.net.0.link = enp0s8" >> /var/lib/lxc/$2/config
lxc-start -n $2
if [ $? -ne 0 ]
then
        echo "demarrage echoue"
        exit 1
fi
sleep 2

lxc-attach -n $2 dhclient
if [ $? -ne 0 ]
then
        echo "attribution d addrese a echoue!"
        exit 1
fi
sleep 1

lxc-ls –fancy
#--------------------------Configuration APACHE2----------------------------------------------------------------------
echo ".....Installation serveur apache.........."
lxc-attach -n $2 -- apt-get install apache2 -y
sleep 1
echo "---------apache  service status ------"
lxc-attach -n $2 -- service apache2 status
#-------------------------------------------------------------------------------------------------------------------------
echo ".....................Fin installation serveur apache......................"


