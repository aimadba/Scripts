#!/bin/sh

# script qui prend en parametre : nom_Archive, Nom_Rep_a_sauvegaredr, adresse_serveur_sauv,
#                                       login et password du compte

arch=$1
dir=$2
ip=$3
login=$4
pass=$5

if [ $# -ne 5 ]
then
        echo " Vous n'avez pas le bon nombre d'arguments "
        echo " ./nomProg nomArchive Nom_rep_sauvegarde addr_serveur login mdp"
        exit 1
fi

tar cvf $arch.tar $dir

if [$? -ne 0]
then
	echo " la creation de l'archive a echoue"
	exit 1
fi

/usr/bin/expect<<EOF
  spawn /usr/bin/sftp $login@$ip
  expect "password:"
  send "$pass\r"
  expect "sftp>"
  send "put $arch.tar upload\r"
  expect "sftp>"
  send "bye\r"

EOF
