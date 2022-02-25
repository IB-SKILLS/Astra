#!/usr/bin/env bash

#Имя соединения
# $2 - IP, $3 - Mask, $4 - Gateway, $5 - DNS
con="Проводное соединение 1"

#Установка пакетов
apt install astra-ad-sssd-client -y

#Вводим краткое доменное имя
hostnamectl set-hostname "$1"

# Задаем адрес шлюза
nmcli con mod "$con" ip4 $2/$3 gw4 $4

# Задаем адреса DNS
nmcli con mod "$con" ipv4.dns "$5"

# Отключаем DHCP, переводим в "ручной" режим настройки
nmcli con mod "$con" ipv4.method manual
nmcli con mod "$con" ipv6.method ignore
nmcli -p con show "$con" | grep ipv4

# Перезапускаем соединение для применения новых настроек
nmcli con down "$con" ; nmcli con up "$con"

#Установка пакетов
apt install fly-admin-ald-server ald-server-common smolensk-security-ald -y

#Обновление пакетов
apt -f install -y

#Вводим полное доменное имя
hostnamectl set-hostname ad.demo.lab

#Настройка сети
echo -n > /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts
echo "$ip  ad.demo.lab     ad" >> /etc/hosts
echo "192.168.10.20   iwdm.demo.lab   iwdm" >> /etc/hosts

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi
