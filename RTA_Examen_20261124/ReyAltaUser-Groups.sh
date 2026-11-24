#!/bin/bash


USUARIO_CLAVE=$1
LISTA=$2

CLAVE=$(sudo grep "^$USUARIO_CLAVE:" /etc/shadow | awk -F ':' '{print $2}')
ANT_IFS=$IFS
IFS=$'\n'
for LINEA in `cat $LISTA |  grep -v ^#`
do
	USUARIO=$(echo  $LINEA |awk -F ',' '{print $1}')
	GRUPO=$(echo  $LINEA |awk -F ',' '{print $2}')
	DIR_HOME=$(echo $LINEA | awk -F ',' '{print $3}')
	sudo groupadd -f $GRUPO
	sudo useradd -m -s /bin/bash -g $GRUPO -d $DIR_HOME -p "$CLAVE" $USUARIO
done
IFS=$ANT_IFS

