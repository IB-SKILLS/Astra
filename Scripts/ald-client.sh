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

#Клиент

#Установка пакетов
apt install ald-client-common ald-admin fly-admin-ald-client ald-client -y

#Обновление пакетов
apt -f install -y

#Вводим доменное имя
hostnamectl set-hostname iwdm

#НАстройки сети
echo -n > /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts
echo "192.168.10.100  ad.demo.lab     ad" >> /etc/hosts
echo "$ip   iwdm.demo.lab   iwdm" >> /etc/hosts

#Для тестов
#ald-client status

#Входим в домен
ald-client join

#Перезагрузка
echo "Please reboot"
