#!/usr/bin/env bash

#Задаем переменные для настройки сети
con="Проводное соединение 1"
ip="192.168.10.10"
mask="/24"
gw="192.168.10.1"
dns="192.168.10.100"

# Задаем адрес шлюза
nmcli con mod "$con" ip4 $ip$mask gw4 $gw

# Задаем адреса DNS
nmcli con mod "$con" ipv4.dns "$dns"

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
echo "192.168.10.100  ad.demo.lab     ad" >> /etc/hosts
echo "192.168.10.20   iwdm.demo.lab   iwdm" >> /etc/hosts

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi
