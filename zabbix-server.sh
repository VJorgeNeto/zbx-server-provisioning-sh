#!/bin/bash
#
# Script: zabbix-server.sh
# Autor: VJorgeNeto (@VJorgeNeto)
# Descrição: Provisiona o Zabbix Server 7.0 LTS com Apache2 e MySQL no Ubuntu Server 24.04.
# Versão: 1.0.0
#
# Uso:
#   sudo ./zabbix-server.sh
#
# Requisitos:
#   - Ubuntu Server 24.04
#   - Conexão com a internet
#   - Permissões de root (sudo)
#
# Funcionalidades:
#   - Instala Apache2, MySQL e Zabbix
#   - Configura banco de dados do Zabbix
#   - Habilita e inicia os serviços necessários
#
# Licença:
#   MIT License
#

set -e

echo "====== PROVISIONAMENTO DO ZABBIX SERVER 7 NO UBUNTU 24.04 ======"

# 1. Timezone
echo "[1/8] Configurando timezone..."
timedatectl set-timezone America/Sao_Paulo
date

# 2. Entrada de senhas
read -s -p "Digite a nova senha para o usuário root do MySQL: " MYSQL_ROOT_PASSWORD
echo
read -s -p "Digite a senha para o usuário 'zabbix' do banco: " ZABBIX_DB_PASSWORD
echo

# 3. MySQL
echo "[2/8] Instalando MySQL Server..."
apt update && apt install -y mysql-server

echo "[3/8] Configurando banco de dados Zabbix..."
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '${ZABBIX_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

# 4. Zabbix + Repositório
echo "[4/8] Instalando Zabbix Server e pacotes necessários..."
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2%2Bubuntu24.04_all.deb
dpkg -i zabbix-release_7.0-2+ubuntu24.04_all.deb
apt update
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo "[5/8] Importando schema para o banco de dados Zabbix..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p${ZABBIX_DB_PASSWORD} zabbix

# 5. Configuração do Zabbix Server
echo "[6/8] Configurando zabbix_server.conf..."
sed -i "s/^# DBPassword=.*/DBPassword=${ZABBIX_DB_PASSWORD}/" /etc/zabbix/zabbix_server.conf

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# 6. Serviços
echo "[7/8] Habilitando e iniciando serviços..."
systemctl enable zabbix-server apache2 php8.3-fpm zabbix-agent --now
systemctl restart apache2 php8.3-fpm

# 7. Locales
echo "[8/8] Corrigindo locales para pt_BR.UTF-8 e en_US.UTF-8..."
apt install -y locales
locale-gen pt_BR.UTF-8 en_US.UTF-8
update-locale
systemctl restart apache2

echo "✅ Instalação finalizada! Acesse http://<SEU_IP>/zabbix para concluir a configuração web."
