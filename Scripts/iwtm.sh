#!/usr/bin/env bash
if [[ "$1" != "" ]]; then
if [[ $(whoami) == "root" ]]; then

#CD/DVD 1 se
mkdir -p /srv/repo/smolensk/main
mount /dev/sr0 /media/cdrom
cp -a /media/cdrom/* /srv/repo/smolensk/main
umount /media/cdrom

#CD/DVD 2 devel
mkdir -p /srv/repo/smolensk/devel
mount /dev/sr1 /media/cdrom
cp -a /media/cdrom/* /srv/repo/smolensk/devel
umount /media/cdrom

#CD/DVD 3 update
mkdir -p /srv/repo/smolensk/update
mount /dev/sr2 /media/cdrom
cp -a /media/cdrom/* /srv/repo/smolensk/update
umount /media/cdrom

#CD/DVD 4 update-devel
mkdir -p /srv/repo/smolensk/update-dev
mount /dev/sr3 /media/cdrom
cp -a /media/cdrom/* /srv/repo/smolensk/update-dev
umount /media/cdrom

#Sources.list
echo -n > /etc/apt/sources.list
echo "# репозиторий основного диска" >> /etc/apt/sources.list
echo "deb file:/srv/repo/smolensk/main smolensk main contrib non-free" >> /etc/apt/sources.list
echo "# репозиторий диска со средствами разработки" >> /etc/apt/sources.list
echo "deb file:/srv/repo/smolensk/devel smolensk main contrib non-free" >> /etc/apt/sources.list
echo "# репозиторий диска с обновлением основного диска" >> /etc/apt/sources.list
echo "deb file:/srv/repo/smolensk/update smolensk main contrib non-free" >> /etc/apt/sources.list
echo "# репозиторий диска с обновлением диска со средствами разработки" >> /etc/apt/sources.list
echo "deb file:/srv/repo/smolensk/update-dev smolensk main contrib non-free" >> /etc/apt/sources.list

#Обновление пакетов
apt update -y
apt dist-upgrade -y
apt -f install -y

#SSH
apt install ssh -y
systemctl enable ssh
systemctl start ssh

#Имя соединения
# $2 - IP, $3 - Маска, $4 - Gateway, $5 - DNS
con="Проводное соединение 1"

# hostname
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

#Настройка сети
echo -n > /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "$2 $1" >> /etc/hosts

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
