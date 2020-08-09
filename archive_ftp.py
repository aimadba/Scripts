import pysftp
import sys
import os
import tarfile
import pexpect


arch = sys.argv[1]
dirt = sys.argv[2]
ip = sys.argv[3]
login = sys.argv[4]
passw = sys.argv[5]


if len (sys.argv) != 6 :
    print ("Vous n'avez pas le bon nombre d'arguments ")
    print ("./nomProg nomArchive Nom_rep_sauvegarde addr_serveur login mdp")
    sys.exit (1)

print("--------------------------------------------------------")
print("Compression avec TAR...\n")
lss = os.listdir(dirt)
out = tarfile.open(name=arch, mode='w:')
for i in lss:
        print("{} --> Ajouter au {} ...".format(i,arch))
        out.add(i)

out.close()

print("\nFIN Compression...\n")
print("--------------------------------------------------------")

print ("liste Contenu du TAR:\n")

t = tarfile.open(name=arch, mode='r')
for member_info in t.getmembers():
    print ("---> {} ".format(member_info.name))
print("--------------------------------------------------------")

print ("\n La copie travers SFTP:\n")
print ("Connexion au serveur SFTP ...\n")

child = pexpect.spawn('sftp '+login+'@'+ip)
child.expect ('[Pp]assword: ')
child.sendline (passw)
child.expect ('sftp> ')
print("uploading ...")
child.sendline('put '+arch+' upload')
child.expect ('sftp> ')
child.sendline ('bye')

print("\n Contenu dossier Upload")
ds = os.listdir("/home/user/upload")
print('---> {}'.format(ds))

print("--------------------------------------------------------")

