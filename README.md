# zbx-server-provisioning-sh

> Script Bash para provisionamento automatizado do Zabbix Server 7.0 LTS com Apache2 e MySQL no Ubuntu Server 24.04.

## 📋 Descrição

Este script realiza toda a instalação e configuração inicial do **Zabbix Server 7.0 LTS**, utilizando:

- **Apache2** como servidor web
- **MySQL** como banco de dados
- **Ubuntu Server 24.04** como sistema operacional

Ele foi criado para facilitar ambientes de testes e laboratórios locais.

## ⚙️ Requisitos

- Ubuntu Server 24.04
- Permissões de superusuário (root)
- Conexão com a internet

## 🚀 Como Usar

### 1. Clone o repositório:

```bash
git clone https://github.com/VJorgeNeto/zbx-server-provisioning-sh.git
cd zbx-server-provisioning-sh
```
### 2. Dê permissão de execução e execute o script:

```bash
chmod +x zabbix-server.sh
sudo ./zabbix-server.sh
```
🧪 O que o script faz?
Instala MySQL Server e Apache2

Adiciona repositório oficial do Zabbix

Instala os pacotes necessários do Zabbix

Cria banco de dados e usuário para o Zabbix

Importa schema e dados iniciais

Habilita e inicia serviços

📁 Estrutura do Projeto

```bash
.
├── zabbix-server.sh
└── README.md
```

📄 Licença
Distribuído sob a licença MIT.

Desenvolvido por @VJorgeNeto 🚀
