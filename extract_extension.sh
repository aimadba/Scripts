#!/bin/sh

#test existance
if [ -e $1 ]
then
	echo "existe"

else
	echo "not exist"
	exit
fi

#test droits
if [ -r $1 ]; then
echo "droit r"
fi
if [ -w $1 ]; then
echo "droit w"
fi
if [ -x $1 ]; then
echo " droit x"
fi

#extraire l'extension
extension=$(echo $1|cut -d. -f2)
echo $extension


if [ $extension = tar ];then

	echo "extension est tar"
	tar xvf $1 -C $2  

elif [ $extension = zip ];then
	echo "extension est zip"
	unzip $1 -d $2
elif [ $extension = tgz ];then
	echo "extension est tgz"
	tar zxvf $1 -C $2	
fi
