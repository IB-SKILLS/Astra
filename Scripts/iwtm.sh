#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then

#Переменные
echo "Введите адрес TM"
read TM
echo "Введите имя компьютера"
read PC

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
systemctl enable ssh.service
systemctl start ssh.service

#Настройка сети
echo -n > /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "$TM $PC" >> /etc/hosts

#Перезагрузка
read -p 'Перезагрузить ПК? ' in
if [[ "$in" == "y" ]]; then
sudo reboot
fi

#Забыл имя ПК
else
echo "Ты забыл про имя ПК!"
fi
