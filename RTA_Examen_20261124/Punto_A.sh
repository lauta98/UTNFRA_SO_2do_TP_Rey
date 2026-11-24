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
