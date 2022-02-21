#!/usr/bin/env bash
if [[ "$1" != "" ]]; then
if [[ $(whoami) == "root" ]]; then

#Имя соединения
# $2 - IP, $3 - Маска, $4 - Gateway, $5 - DNS
con="Проводное соединение 1"

#Установка пакетов
apt install astra-ad-sssd-client -y

#Вводим краткое доменное имя
hostnamectl set-hostname "$1"

# Задаем адрес шлюза
nmcli con mod "$con" ip4 $2$3 gw4 $4

# Задаем адреса DNS
nmcli con mod "$con" ipv4.dns "$5"

# Отключаем DHCP, переводим в "ручной" режим настройки
nmcli con mod "$con" ipv4.method manual
nmcli con mod "$con" ipv6.method ignore
nmcli -p con show "$con" | grep ipv4

# Перезапускаем соединение для применения новых настроек
nmcli con down "$con" ; nmcli con up "$con"

#Вход в домен Active Directory
astra-ad-sssd-client -d demo.lab -u Administrator -p xxXX1234 -y

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi

#Выполнено не от рута
else
echo "Запусти скрипт через sudo!"
fi

#Забыл имя ПК
else
echo "Ты забыл про имя ПК!"
fi
