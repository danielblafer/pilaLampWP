#!/bin/bash

function comprobar_error(){

        if [ $? -ne 0 ];then
            echo "Error en la ejecucion del comando"
            exit 1
        fi
clear
}

echo "Comenzamos a Upgradear el sistema"
echo "----------------------------------------"
sudo apt-get upgrade -y

comprobar_error



echo "Comenzamos a actualizar el sistema"
echo "----------------------------------------"
    sudo apt-get update -y
    comprobar_error

echo "Instalamos Apache2"
echo "----------------------------------------"
    sudo apt install apache2 -y
    comprobar_error

echo "Instalamos MySQLServer"
echo "----------------------------------------"
sudo apt install mysql-server -y
comprobar_error

echo "Instalamos PHP"
echo "----------------------------------------"
sudo apt install php -y
comprobar_error

echo "Instalamos la dependencia mysql para php"
echo "----------------------------------------"
sudo apt install php-mysql -y
comprobar_error

echo "Instalamos el modulo libApache"
echo "----------------------------------------"
sudo apt install libapache2-mod-php -y
comprobar_error

echo "Instalamos el Cliente PHP"
echo "----------------------------------------"
sudo apt install php-cli -y
comprobar_error

echo "Habilitamos Y Reiniciamos Apache"
echo "----------------------------------------"
sudo systemctl enable apache2
sudo systemctl start apache2

echo "----------------------------------------"
echo "Ajustamos los permisos"
sudo chmod -R 0755 /var/www/html/

clear

echo "preparacion especifica para Wordpress"
echo "----------------------------------------"
apt install -y php-bcmath php-curl php-imagick php-mbstring php-xml php-zip
comprobar_error

echo "Habilitamos modulos y Reiniciamos apache"
echo "----------------------------------------"
a2enmod proxy proxy_http proxy_ajp rewrite deflate headers proxy_balancerproxy_connecta2enmod proxy_html lbmethod_byrequests
systemctl restart apache2



echo "Descargamos Wordpress y preparamos el entorno"
echo "----------------------------------------"
cd /tmp
wget https://es.wordpress.org/latest-es_ES.tar.gz
tar xf latest-es_ES.tar.gz -C /tmp
mv wordpress/* /var/www/html/
cd ~

clear

echo "Establecemos los permisos necesarios en la carpeta por defecto"
echo "----------------------------------------"
chown :www-data /var/www/html/ -R
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

echo "Recargamos la configuracion de Apache 'por si acaso'"
echo "----------------------------------------"
systemctl reload apache2
comprobar_error

clear


echo "Instalamos la base de datos y realizamos una Securizacion"
echo "----------------------------------------"
apt-get install mysql-server -y
clear
mysql_secure_installation

echo "Estado"
echo "------------------------------------------------------"
systemctl status mysql.service | grep Active
echo "----------------------------------------"
echo "--RECUERDA NECESITAMOS CREAR UN USUARIO EN LA BBDD---"
echo "------------------------------------------------------"
echo "Recordatorio (ejemplo):"
echo "----------------------------------------"

echo "create database wordpress;"
echo "use wordpress;"
echo "CREATE USER 'usuario'@'localhost' IDENTIFIED BY 'usuario+';"
echo "GRANT ALL PRIVILEGES ON * . * TO 'usuario'@'localhost';"
echo "FLUSH PRIVILEGES;"
