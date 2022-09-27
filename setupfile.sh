#!/bin/sh

#PART 0: set current user to be superuser and add him to sudoers
#su root -c "/sbin/usermod -aG sudo user" #not working
echo "adding user to sudoers"
su -c "echo -e '\nuser ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

#PART 0.1: add sbin paths to environment
echo "creating sbin paths"
sudo echo -e "\nexport PATH=$PATH:/sbin" >> /home/user/.bash_profile #alternatively ~/.bash_profile
sudo echo -e "\nexport PATH=$PATH:/sbin" >> /home/user/.bashrc #alternatively ~/.bashrc

#reload bash profile
echo "reloading bash profile"
. /home/user/.bash_profile
. /home/user/.bashrc

#PART 0.2: rename computer:
echo "renaming computer"
sudo "echo 'workmachine' > /etc/hostname"

#PART 1: remove cd from resrouces and add resources for apps installation
#========================================================================

echo "Updating resources"
sudo sed -i '/cdrom/d' /etc/apt/sources.list
sudo echo -e "\ndeb http://deb.debian.org/debian bullseye main\ndeb-src http://deb.debian.org/debian/ bullseye main\n\ndeb http://security.debian.org/debian-security bullseye-security main contrib\ndeb-src http://security.debian.org/debian-security bullseye-security main contrib\n\ndeb http://deb.debian.org/debian/ bullseye-updates main contrib\ndeb-src http://deb.debian.org/debian/ bullseye-updates main contrib" > /etc/apt/sources.list

echo "Installing software" #in interactive shell you need to use echo -e

#update apt
sudo apt update

#PART 2: install RDP
#=======================================================

#PART 2.1 OPTION A: install xrdp using apt-get
#don't use this for debian bullseye (11), as it does not work with gnome
sudo apt-get install xrdp

#PART 2.1 OPTION B: install xrdp manually
#an alternative way, custom version compiled
#Following packages are necessary for xrdp compilation
#install compiler (will be used for installation of new version of xrdp)
#sudo apt-get install make
#sudo apt-get install gcc
#sudo apt-get install libssl-dev
#sudo apt-get install libpam0g-dev
#sudo apt-get install libx11-dev
#sudo apt-get install libxfixes-dev
#sudo apt-get install libxrandr-dev
#wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.20/xrdp-0.9.20.tar.gz
#tar xvzf xrdp-0.9.20.tar.gz
#cd xrdp-0.9.20
#./configure
#make install
#install
#cd ..

#PART 2.2 - RUN xrdp
sudo systemctl enable --now xrdp
systemctl start xrdp

#PART 3: install net-tools
#=========================
sudo apt-get install net-tools

#install vscode

#...

#PART END: reboot
#================
#sudo reboot
