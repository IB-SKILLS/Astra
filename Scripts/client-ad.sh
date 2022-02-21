#!/usr/bin/env bash
if [[ "$1" != "" ]]; then

#Установка пакетов
apt install astra-ad-sssd-client -y

#Вводим краткое доменное имя
hostnamectl set-hostname "$1"

#Вход в домен Active Directory
astra-ad-sssd-client -d demo.lab -u Administrator -p xxXX1234 -y

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi

#Забыл имя ПК
else
echo "Ты забыл про имя ПК!"
fi
