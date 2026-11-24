#!/bin/bash
# Punto B - Script de alta de usuarios y grupos
# Base: ejemplo Bucle_for/2_for_cmd_lista.sh del repo UTN-FRA_SO_Bash
git clone https://github.com/upszot/UTN-FRA_SO_Bash.git
cp UTN-FRA_SO_Bash/Bucle_for/2_for_cmd_lista.sh ~/ReyAltaUser-Groups.sh
nano ~/ReyAltaUser-Groups.sh
chmod +x ~/ReyAltaUser-Groups.sh
sudo cp ~/ReyAltaUser-Groups.sh /usr/local/bin/
ReyAltaUser-Groups.sh lautaro ~/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt
cp /usr/local/bin/ReyAltaUser-Groups.sh ~/RTA_Examen_20261124/

# Verificacion
grep 2P /etc/passwd
sudo grep -E 'lautaro|2P' /etc/shadow
ls -l /work
