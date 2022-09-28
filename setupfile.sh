#!/bin/sh

#PART 0: set current user to be superuser and add him to sudoers
#su root -c "/sbin/usermod -aG sudo user" #not working
echo "adding user to sudoers"
yes 0000 | su -c "echo -e '\nuser ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

#PART 0.1: add sbin paths to environment
echo "creating sbin paths"
su -c "echo -e '\nexport PATH=$PATH:/sbin' >> /home/user/.bash_profile #alternatively ~/.bash_profile"
su -c "echo -e '\nexport PATH=$PATH:/sbin' >> /home/user/.bashrc #alternatively ~/.bashrc"

#reload bash profile
echo "reloading bash profile"
. /home/user/.bash_profile
. /home/user/.bashrc

#PART 0.2: rename computer:
echo "renaming computer"
yes 0000 | su -c "echo 'workmachine' > /etc/hostname" #sudo would not work, the arrow symbol has privilegies of current shell, not sudo

#PART 1: remove cd from resrouces and add resources for apps installation
#========================================================================

echo "Updating resources"
sudo sed -i '/cdrom/d' /etc/apt/sources.list
yes 0000 | su -c "echo -e '\ndeb http://deb.debian.org/debian bullseye main\ndeb-src http://deb.debian.org/debian/ bullseye main\n\ndeb http://security.debian.org/debian-security bullseye-security main contrib\ndeb-src http://security.debian.org/debian-security bullseye-security main contrib\n\ndeb http://deb.debian.org/debian/ bullseye-updates main contrib\ndeb-src http://deb.debian.org/debian/ bullseye-updates main contrib' > /etc/apt/sources.list"

#update apt so that updated file /etc/apt/sources.list takes effect for apt (i.e. apt must reload sources.list file)
sudo apt update
sudo apt-get update

echo "Installing software" #in interactive shell you need to use echo -e

#PART 2: install gnome (disabled now)
#=====================
#sudo apt-get purge gnome-2048 aisleriot cheese gnome-chess gnome-contacts simple-scan evolution five-or-more four-in-a-row yelp hitori gnome-klotski libreoffice-common libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer lightsoff gnome-mahjongg gnome-maps gnome-mines gnome-music gnome-nibbles malcontent seahorse quadrapassel iagno rhythmbox gnome-robots shotwell gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex transmission-gtk totem gnome-weather -y
sudo apt-get install gnome-core network-manager-gnome gnome-calculator gnome-characters gnome-clocks gnome-color-manager gnome-disk-utility evince gnome-shell-extension-prefs nautilus firefox-esr gnome-font-viewer eog im-config gnome-logs gnome-screenshot gnome-system-monitor gnome-terminal gedit gnome-todo -y --ignore-missing

#PART 3: install RDP
#=======================================================

#PART 3.1 OPTION A: install xrdp using apt-get
#don't use this for debian bullseye (11), as it does not work with gnome
yes | sudo apt-get install xrdp

#PART 3.1 OPTION B: install xrdp manually
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

#PART 3.2 - RUN xrdp
yes 0000 | sudo systemctl enable --now xrdp
yes 0000 | sudo systemctl start xrdp

#PART 4: install net-tools
#=========================
yes | sudo apt-get install net-tools

#PART 5: install vscode
#======================

#PART 5.1 OPTION A: install vscode using microsoft gpg key
#PART 5.1.A.1 install gpg keys and add necessary sources
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
yes | sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
yes | sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo rm -f packages.microsoft.gpg

#PART 5.1.A.2 install vscode
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders

#create desktop link
ln -s /usr/share/code/code /home/user/Desktop/code

#PART 5.1 OPTION B: install vscode usin snap, that's not recommended (see reddit - slow, takes lot of ram, etc...), so that vscode runs packaged in snap daemon
#sudo apt install snapd - install snapd first, if not yet installed
#sudo snap install --classic code # or code-insiders

#PART 6: visual settings customization
#=====================================
#set font scaling factor from 1.0 to 1.1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

#PART END: delete this file from login folder and reboot
#=======================================================
sudo rm /etc/profile.d/setupfile.sh
sudo reboot
