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
