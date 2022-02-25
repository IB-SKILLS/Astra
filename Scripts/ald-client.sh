#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then

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
apt install ald-client-common ald-admin fly-admin-ald-client ald-client -y

#Обновление пакетов
apt -f install -y

#Вводим краткое доменное имя
hostnamectl set-hostname iwdm

#Настройки сети
echo -n > /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts
echo "192.168.10.200  ad.demo.lab     ad" >> /etc/hosts
echo "$ip   iwdm.demo.lab   iwdm" >> /etc/hosts

#Входим в домен
ald-client join

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi

#Выполнено не от рута
else
echo "Запусти скрипт через sudo!"
fi
