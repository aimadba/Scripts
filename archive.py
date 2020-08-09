import os
import stat
import sys
import tarfile
import zipfile

arch = sys.argv[1]
repp = sys.argv[2]

#path = "./fg.tar"

# test existance
print("---------------------------------------------")

print ("-----> TEST Existance")

if os.path.exists(arch):
        print("--> {} : existe".format(arch))
else:
        print("--> {} : n existe pas".format(arch))
        exit(1)
print("---------------------------------------------")

# Les droits

print ("-----> TEST Droit")

if os.access(arch,os.R_OK):
        print("--> Read permission")

if os.access(arch,os.W_OK):
        print("--> Write permission")

if os.access(arch,os.X_OK):
        print("--> Execute permission")
print("---------------------------------------------")


#extension

print ("-----> Extraction ")

if (arch.endswith(".tar")):
    print("---> utilisation TAR...")
    t = tarfile.open(arch, 'r|')
    t.extractall(repp)
    print (os.listdir(repp))
    exit(0)

if (arch.endswith(".zip")):
    print("---> utilisation ZIP...")
    z = zipfile.ZipFile(arch, "r")
    z.extractall(repp)
    z.close()
    print (os.listdir(repp))

if (arch.endswith(".tgz")):
    print("---> utilisation TGZ...")
    t = tarfile.open(arch, 'r|gz')
    t.extractall(repp)
    print (os.listdir(repp))
    exit(0)
