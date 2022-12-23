#!/bin/sh

#PART BASIC SETUP: set current user to be superuser and add him to sudoers, create variables and aliases, name computer
#======================================================================================================================
#su root -c "/sbin/usermod -aG sudo user" #not working
echo "adding user to sudoers"
yes 0000 | su -c "echo -e '\nuser ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

#echo "press Enter to add sbin paths to environment and to create aliases"
#read x

#PART BASIC SETUP.1: add sbin paths to environment
echo "creating sbin paths"
yes 0000 | su -c "echo -e '\nexport PATH=$PATH:/sbin' >> /home/user/.bash_profile #alternatively ~/.bash_profile"
yes 0000 | su -c "echo -e '\nexport PATH=$PATH:/sbin' >> /home/user/.bashrc #alternatively ~/.bashrc"

#PART BASIC SETUP.2: export python3 alias (will be useful in future to avoid always typing `python3`)
echo "creating aliases"
yes 0000 | su -c "echo -e '\nalias python=\"python3\"' >> /home/user/.bash_profile"
yes 0000 | su -c "echo -e '\nalias python=\"python3\"' >> /home/user/.bashrc"

#PART BASIC SETUP.2.1: create python3 symlink in /usr/bin/env (will be necessary for aws installation)
sudo ln -s /usr/bin/python3 /usr/bin/python

#reload bash profile
echo "reloading bash profile"
. /home/user/.bash_profile
. /home/user/.bashrc

#echo "press Enter to rename computer"
#read x

#PART BASIC SETUP.3: rename computer:
echo "renaming computer"
yes 0000 | su -c "echo 'workmachine' > /etc/hostname" #sudo would not work, the arrow symbol has privilegies of current shell, not sudo

#echo "press Enter to disable interactive prompts"
#read x

#PART BASIC SETUP.4: disable interactive window for service restart prompt (prevent "Restart services during package upgrades without asking?" dialog)
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

#echo "press Enter to update resources file"
#read x

#PART RESOURCE UPDATE: remove cd from resrouces and add resources for apps installation
#======================================================================================

echo "Updating resources"
sudo sed -i '/cdrom/d' /etc/apt/sources.list
yes 0000 | su -c "echo -e '\ndeb http://deb.debian.org/debian bookworm main contrib non-free\ndeb-src http://deb.debian.org/debian/ bookworm main contrib non-free\n\ndeb http://security.debian.org/debian-security bookworm-security main contrib non-free\ndeb-src http://security.debian.org/debian-security bookworm-security main contrib non-free\n\ndeb http://deb.debian.org/debian/ bookworm-updates main contrib non-free\ndeb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free' > /etc/apt/sources.list"

#echo "press Enter to update apt with new resources"
#read x

#update apt so that updated file /etc/apt/sources.list takes effect for apt (i.e. apt must reload sources.list file)
sudo apt update
sudo apt-get update

#echo "press Enter to install gnome"
#read x

echo "Installing software" #in interactive shell you need to use echo -e

#PART GNOME INSTALL
#==================
#sudo apt-get purge gnome-2048 aisleriot cheese gnome-chess gnome-contacts simple-scan evolution five-or-more four-in-a-row yelp hitori gnome-klotski libreoffice-common libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer lightsoff gnome-mahjongg gnome-maps gnome-mines gnome-music gnome-nibbles malcontent seahorse quadrapassel iagno rhythmbox gnome-robots shotwell gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex transmission-gtk totem gnome-weather -y
yes | sudo apt-get install gnome-core network-manager-gnome gnome-calculator gnome-characters gnome-clocks gnome-color-manager gnome-disk-utility evince gnome-shell-extension-prefs nautilus firefox-esr gnome-font-viewer eog im-config gnome-logs gnome-screenshot gnome-system-monitor gnome-terminal gedit gnome-todo firmware-sof-signed alsa-utils -y --ignore-missing

#echo "press Enter to install xrdp"
#read x

#PART INSTALL RDP
#================

#PART INSTALL RDP.1 OPTION A: install xrdp using apt-get
#use this for debian bookworm (12)
#yes | sudo apt-get install xrdp #TEMPORARY

#PART INSTALL RDP.1 OPTION B: install xrdp manually
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

#echo "press Enter to activate xrdp"
#read x

#PART 3.2 - RUN xrdp
yes 0000 | sudo systemctl enable --now xrdp
yes 0000 | sudo systemctl start xrdp

#echo "press Enter to install net-tools"
#read x

#PART NET_TOOLS: install net-tools
#=================================
yes | sudo apt-get install net-tools

#echo "press Enter to prepare vscode installation"
#read x

#PART VSCODE: install vscode
#===========================

#PART VSCODE.1 OPTION A: install vscode using microsoft gpg key
#PART VSCODE.1.A.1 install gpg keys and add necessary sources
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
yes | sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
yes | sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo rm -f packages.microsoft.gpg

#echo "press Enter to install vscode"
#read x

#PART VSCODE.1.A.2 install vscode
yes y | sudo apt install apt-transport-https
sudo apt update
yes y | sudo apt install code # or code-insiders

#PART VSCODE.1 OPTION B: install vscode usin snap, that's not recommended (see reddit - slow, takes lot of ram, etc...), so that vscode runs packaged in snap daemon
#sudo apt install snapd - install snapd first, if not yet installed
#sudo snap install --classic code # or code-insiders

#echo "press Enter to install pip"
#read x

#PART PIP: install pip
#===================
yes | sudo apt-get install python3-pip

#echo "press Enter to install curl"
#read x

#PART CURL: install curl
#====================
yes | sudo apt-get install curl

#echo "press Enter to install aws-cli"
#read x

#PART AWS: install aws-cli
#=======================
yes | sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
yes | sudo unzip awscliv2.zip
yes | sudo ./aws/install

#echo "press Enter to update gnome scaling settings"
#read x

#PART VISUALSETTINGS: visual settings customization
#=====================================
#set font scaling factor from 1.0 to 1.1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

#PART SAMBA_BOOKMARK: add samba connection to favorites
#=========================================
echo "write name of your Windows computer and press Enter. This step adds gnome Nautilus bookmark, which links to your Windows computer via smb protocol"
read COMPNAME
sudo echo "smb://$COMPNAME/users/ users on $COMPNAME" > /home/user/.config/gtk-3.0/bookmarks

#echo "press Enter to reboot"
#read x

#PART END: delete this file from login folder and reboot
#=======================================================
sudo rm /etc/profile.d/setupfile.sh
sudo reboot
