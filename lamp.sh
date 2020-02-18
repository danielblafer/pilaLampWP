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
apt-get upgrade -y

comprobar_error



echo "Comenzamos a actualizar el sistema"
echo "----------------------------------------"
    apt-get update -y
    comprobar_error

echo "Instalamos Apache2"
echo "----------------------------------------"
    apt install apache2 -y
    comprobar_error
    rm /var/www/html/index.html
    
echo "Instalamos MySQLServer"
echo "----------------------------------------"
apt install mysql-server -y
comprobar_error

echo "Instalamos PHP"
echo "----------------------------------------"
apt install php -y
comprobar_error

echo "Instalamos la dependencia mysql para php"
echo "----------------------------------------"
apt install php-mysql -y
comprobar_error

echo "Instalamos el modulo libApache"
echo "----------------------------------------"
apt install libapache2-mod-php -y
comprobar_error

echo "Instalamos el Cliente PHP"
echo "----------------------------------------"
apt install php-cli -y
comprobar_error

echo "Habilitamos Y Reiniciamos Apache"
echo "----------------------------------------"
systemctl enable apache2
systemctl start apache2

echo "----------------------------------------"
echo "Ajustamos los permisos"
chmod -R 0755 /var/www/html/

clear

echo "preparacion especifica para Wordpress"
echo "----------------------------------------"
apt install -y php-bcmath php-curl php-imagick php-mbstring php-xml php-zip
comprobar_error

echo "Habilitamos modulos y Reiniciamos apache"
echo "----------------------------------------"
a2enmod proxy proxy_http proxy_ajp rewrite deflate headers proxy_balancerproxy_connect proxy_html lbmethod_byrequests
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
cd /var/www/html/
chown www-data:www-data  -R * 
find . -type d -exec chmod 755 {} \;  
find . -type f -exec chmod 644 {} \;

echo "Recargamos la configuracion de Apache 'por si acaso'"
echo "----------------------------------------"
systemctl reload apache2
comprobar_error

clear


echo "Realizamos una Securizacion"
mysql_secure_installation
