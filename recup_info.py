import subprocess
import sys

user = subprocess.Popen('whoami',shell=True, stdout=subprocess.PIPE)
us = user.communicate()[0]
u = us.decode().strip('\n')
print (u)

id_user = subprocess.Popen('id -u $u', shell=True, stdout=subprocess.PIPE)
idd = id_user.communicate()[0]
id_u = idd.decode()
print(id_u)

groups = subprocess.Popen('groups $id_u', shell=True, stdout=subprocess.PIPE)
gr = groups.communicate()[0]
grr = gr.decode()
print (grr)

file= '''cat << EOF > USER-{}.txt
USER : {}
ID_USER : {}
{}
EOF
'''.format(u,u,id_u,grr)

res = subprocess.Popen(file,shell=True, universal_newlines=True, stdout=subprocess.PIPE)
ss = res.communicate()[0]

print (ss)
