#!usr/bin/bash

#Check if user is root or not
if [[ $USER == 'root' ]]
then
	echo 'You are root now,please logout first!!'
	exit
fi

#require in the same dir as the scripts
current_working_dir=`pwd`
__file__=`realpath $BASH_SOURCE`
file_dir=`dirname $__file__`

if [[ $current_working_dir != $file_dir ]]
then
	echo "file dir :" $file_dir 
	echo "current working dir :" $current_working_dir 
	echo "You are not in the same folder of the file . Please go back !"
	exit
fi

#update normal packages
sudo apt update && sudo apt upgrade -y

#install some useful packages
sudo apt install tree -y
sudo apt install keychain -y
sudo apt install wget -y
sudo apt install curl -y

sudo apt install openssh-server -y
sudo apt install screen -y
sudo apt install tmux -y

sudo apt install git -y
sudo apt install nodejs npm -y

sudo apt install docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin -y

curl -LsSf https://astral.sh/uv/install.sh | sh

#check if using gui or not to install packges that support gui
if [[ ! -z `type Xorg` ]]
then
	#install xfce4
	sudo apt install xfce4-terminal -y
	sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper #Set xfce4 as default terminal

	#install media
	sudo apt install vlc -y
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install ./google-chrome-stable_current_amd64.deb -y
	rm google-chrome-stable_current_amd64.deb

	#grub-customizer 
	sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
	sudo apt update
	sudo apt install grub-customizer -y

	#Custom grub
	sudo chown -R root:root ubuntu
	if [[ ! -d /boot/grub/themes ]]
	then
		sudo mkdir /boot/grub/themes
	fi
	sudo mv ubuntu /boot/grub/themes

	sudo chown root:root grub
	sudo mv grub /etc/default
	sudo update-grub

	#install vietnamese telex
	sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
	sudo apt-get update
	sudo apt-get install ibus ibus-bamboo --install-recommends -y
	ibus restart

	# Set ibus-bamboo as default keyboard

	env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"


	#setup nerdfont for nvim-display
	if [  ! -d /home/$USER/.local/share/fonts ]
	then
		mkdir /home/$USER/.local/share/fonts
	fi

	mv AgaveNerdFontMono-Regular.ttf /home/$USER/.local/share/fonts
	fc-cache -f -v

	
	#Setup screen background
	if [[  ! -d /home/$USER/Downloads/wallpaper ]]
	then
		mkdir /home/$USER/Downloads/wallpaper
	fi
	mv screen_background.jpg /home/$USER/Downloads/wallpaper
	gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Downloads/wallpaper/screen_background.jpg"

	
	#Setup xfce4-terminal background
	mv terminal_background.jpg /home/$USER/Downloads/wallpaper #setup wallpaper for terminal

	if [[ ! -d  /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml ]]
	then
		mkdir -p /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml 
	fi

	echo '''<?xml version="1.0" encoding="UTF-8"?>

	<channel name="xfce4-terminal" version="1.0">
	<property name="background-mode" type="string" value="TERMINAL_BACKGROUND_IMAGE"/>
	<property name="background-image-shading" type="double" value="0.5"/>
	<property name="font-name" type="string" value="Agave Nerd Font Mono 12"/>
	<property name="shortcuts-no-menukey" type="bool" value="false"/>
	<property name="background-image-file" type="string" value="/home/'''$USER'''/Downloads/wallpaper/terminal_background.jpg"/>
	<property name="background-image-style" type="string" value="TERMINAL_BACKGROUND_STYLE_FILLED"/>
	</channel>
	''' >>/home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml #write setting to xfce4-terminal

fi


#install drawdb
git clone https://github.com/drawdb-io/drawdb
cd drawdb
docker build -t drawdb .
docker create --name drawdb_container -p 8080:80 drawdb


#create the main python venv(manage other venvs)
apt install python3-venv
if [ ! -d /py_virtual ]
then
	mkdir /py_virtual
	$(python3 -m venv /py_virtual)
fi


#add auto use python virtual environment on startup
sudo bash -c 'echo if [[ \$\(whoami\) == \"root\" ]] >> /etc/bash.bashrc'
sudo bash -c 'echo then >> /etc/bash.bashrc '
sudo bash -c 'echo "    source /py_virtual/bin/activate" >> /etc/bash.bashrc'
sudo bash -c 'echo fi >> /etc/bash.bashrc'

echo 'source /py_virtual/bin/activate'>>/home/$USER/.bashrc


#install python libraries
source /py_virtual/bin/activate
pip install pynvim
pip install pyright
pip install cookiecutter


reboot

#wish list

#create service for run drawdb everytime turn pc on

#setup for Tabby
#setup for Tabby
#setup for zsh shell and ohmyzsh
#setup startship

