#!/usr/bin/env bash

#Установка пакетов
apt install astra-ad-sssd-client -y

#Вводим краткое доменное имя
hostnamectl set-hostname iwdm

#Вход в домен Active Directory
astra-ad-sssd-client -d demo.lab -u Administrator -p xxXX1234 -y

#Перезагрузка
echo "Please reboot"
