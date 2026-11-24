sudo whoami
sudo apt update
sudo apt install -y git
git clone https://github.com/upszot/UTN-FRA_SO_Examenes.git
./UTN-FRA_SO_Examenes/202406/script_Precondicion.sh
source ~/.bashrc && history -a
ls ~/RTA_Examen_*
sudo fdisk /dev/sdc << EOF
n
p
1


t
8e
w
EOF

sudo fdisk /dev/sdd << EOF
n
p
1


t
8e
w
EOF

lsblk
sudo wipefs -a /dev/sdc1 /dev/sdd1
sudo pvcreate /dev/sdc1 /dev/sdd1
sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1
sudo pvs
sudo vgs
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap
sudo lvs
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo mkdir -p /var/lib/docker /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
sudo swapon /dev/mapper/vg_temp-lv_swap
sudo tee -a /etc/fstab << FIN
/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0
/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0
/dev/mapper/vg_temp-lv_swap none swap sw 0 0
FIN

sudo mount -a
df -h | grep -E 'docker|work'
free -h
cat ~/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt
#!/bin/bash
LISTA=$1
ANT_IFS=$IFS
IFS=$'\n'
for LINEA in `cat $LISTA |  grep -v ^#`; do 	USUARIO=$(echo  $LINEA |awk -F ':' '{print $1}'); 	GRUPO=$(echo  $LINEA |awk -F ':' '{print $2}'); 	echo "sudo useradd -m -s /bin/bash -g $GRUPO $USUARIO"; done
IFS=$ANT_IFS
IFS=$' \t\n'
git clone https://github.com/upszot/UTN-FRA_SO_Bash.git
cp UTN-FRA_SO_Bash/Bucle_for/2_for_cmd_lista.sh ~/ReyAltaUser-Groups.sh
nano ~/ReyAltaUser-Groups.sh
chmod +x ~/ReyAltaUser-Groups.sh
sudo cp ~/ReyAltaUser-Groups.sh /usr/local/bin/
ReyAltaUser-Groups.sh lautaro ~/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt
cp /usr/local/bin/ReyAltaUser-Groups.sh ~/RTA_Examen_20261124/
grep 2P /etc/passwd
sudo grep -E 'lautaro|2P' /etc/shadow
ls -l /work
cat > ~/RTA_Examen_20261124/Punto_B.sh << 'FIN_PUNTO_B'
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
FIN_PUNTO_B

ls -l ~/RTA_Examen_20261124/
cat > ~/RTA_Examen_20261124/Punto_A.sh << 'FIN_PUNTO_A'
#!/bin/bash
# Punto A - LVM (metodologia del machete de LVM)

# Identificar discos
lsblk
sudo fdisk -l

# Particionar con tipo Linux LVM (8e)
sudo fdisk /dev/sdc << EOF
n
p
1


t
8e
w
EOF
sudo fdisk /dev/sdd << EOF
n
p
1


t
8e
w
EOF

# Limpiar firmas, crear PV y VG
sudo wipefs -a /dev/sdc1 /dev/sdd1
sudo pvcreate /dev/sdc1 /dev/sdd1
sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1

# Crear LV
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

# Formatear
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap

# Montar y activar swap
sudo mkdir -p /var/lib/docker /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
sudo swapon /dev/mapper/vg_temp-lv_swap

# Persistencia ante reinicio
sudo tee -a /etc/fstab << FIN
/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0
/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0
/dev/mapper/vg_temp-lv_swap none swap sw 0 0
FIN
sudo mount -a
FIN_PUNTO_A

ls -l ~/RTA_Examen_20261124/Punto_A.sh
tail -n 12 ~/RTA_Examen_20261124/Punto_A.sh
sudo vgs
sudo lvextend -L +400M /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
df -h /var/lib/docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -a -G docker lautaro
docker run hello-world
cd ~/UTN-FRA_SO_Examenes/202406/docker/
sed -i 's/Tu-Nombre Tu-Apellido/Lautaro Rey/; s/Tu-Division/111/' index.html
cat index.html
cat > Dockerfile << EOF
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF

docker build -t lautarey/web1-rey:latest .
docker image list
cat > run.sh << EOF
#!/bin/bash
docker run -d --restart always -p 8080:80 lautarey/web1-rey:latest
EOF

chmod +x run.sh
./run.sh
docker ps
curl localhost:8080
docker login -u lautarey
docker push lautarey/web1-rey:latest
cp run.sh ~/RTA_Examen_20261124/
docker login -u lautarey
docker login
docker push lautarey/web1-rey:latest
cat > ~/RTA_Examen_20261124/Punto_C.sh << 'FIN'
# lv_docker (8 MB) no alcanza para la imagen: se amplia con lvextend
sudo lvextend -L +400M /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -a -G docker lautaro
cd ~/UTN-FRA_SO_Examenes/202406/docker/
sed -i 's/Tu-Nombre Tu-Apellido/Lautaro Rey/; s/Tu-Division/111/' index.html
cat > Dockerfile << EOF
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF
docker build -t lautarey/web1-rey:latest .
cat > run.sh << EOF
#!/bin/bash
docker run -d --restart always -p 8080:80 lautarey/web1-rey:latest
EOF
chmod +x run.sh
./run.sh
docker login
docker push lautarey/web1-rey:latest
cp run.sh ~/RTA_Examen_20261124/
FIN

ls -l ~/RTA_Examen_20261124/
sudo apt install -y wget gpg
UBUNTU_CODENAME=jammy
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update && sudo apt install -y ansible
sudo apt install -y wget gpg
ansible --version
cd ~/UTN-FRA_SO_Examenes/202406/ansible
cat > roles/2do_parcial/vars/main.yml << 'FIN'
---
# vars file for 2do_parcial
alumno_nombre: "Lautaro"
alumno_apellido: "Rey"
alumno_division: "111"
FIN

mkdir -p roles/2do_parcial/templates
cat > roles/2do_parcial/templates/datos_alumno.j2 << 'FIN'
Nombre: {{ alumno_nombre }} Apellido: {{ alumno_apellido }}
Division: {{ alumno_division }}
FIN

cat > roles/2do_parcial/templates/datos_equipo.j2 << 'FIN'
IP: {{ ansible_default_ipv4.address }}
Distribución: {{ ansible_distribution }} {{ ansible_distribution_version }}
Cantidad de Cores: {{ ansible_processor_vcpus }}
FIN

cat > roles/2do_parcial/tasks/main.yml << 'FIN'
---
# tasks file for 2do_parcial

- name: "Crear estructura de directorios"
  become: yes
  file:
    path: "/tmp/2do_parcial/{{ item }}"
    state: directory
    mode: '0775'
    recurse: yes
  with_items:
    - alumno
    - equipo

- name: "Generar datos_alumno.txt"
  become: yes
  template:
    src: datos_alumno.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt

- name: "Generar datos_equipo.txt"
  become: yes
  template:
    src: datos_equipo.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

- name: "add NOPASSWD in sudoers for group 2PSupervisores"
  become: yes
  lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%2PSupervisores'
    line: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
    validate: 'visudo -cf %s'
FIN

ls -R roles/2do_parcial
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
ssh lautaro@127.0.0.1
ansible-playbook -i inventory/hosts playbook.yml
cat /tmp/2do_parcial/alumno/datos_alumno.txt /tmp/2do_parcial/equipo/datos_equipo.txt
sudo grep 2PSupervisores /etc/sudoers
cat > ~/RTA_Examen_20261124/Punto_D.sh << 'FIN'
# Instalar Ansible
sudo apt install -y wget gpg
UBUNTU_CODENAME=jammy
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update && sudo apt install -y ansible
# SSH
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
# Ejecutar
cd ~/UTN-FRA_SO_Examenes/202406/ansible
ansible-playbook -i inventory/hosts playbook.yml
FIN

ls -l ~/RTA_Examen_20261124/
df -h | grep -E 'docker|work'
swapon -s
docker ps
curl localhost:8080
cd ~
git config --global user.name "Lautaro Rey"
git config --global user.email "lauta.dq@gmail.com"
git clone https://github.com/lauta98/UTNFRA_SO_2do_TP_Rey.git
cd UTNFRA_SO_2do_TP_Rey
cp -r ~/UTN-FRA_SO_Examenes/202406 .
cp -r ~/RTA_Examen_20261124 .
history -a
