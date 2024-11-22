#!usr/bin/bash

#Require login as root user
if [[ ! $(whoami) =~ 'root' ]]
then
	echo 'You are not root !!'
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

#get current user
current_user=`who | awk '{print $1}' | head -n 1`

#install some useful packages
apt install sqlite3 -y
apt install tree -y
apt install keychain -y
apt install wget -y
apt install curl -y
apt install neovim -y

apt update && apt upgrade -y #check package update to prevent conflict

apt install python3-venv -y
apt install apache2 -y
apt install openssh-server -y
apt install screen -y
apt install git -y
apt install silversearcher-ag -y
apt install libxcb-cursor-dev -y #for matplotlib

#check if using gui or not to install packges that support gui
if [[ ! -z `type Xorg` ]]
then
	#install xfce4
	apt install xfce4-terminal -y
	update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper #Set xfce4 as default terminal

	#install media
	apt install okular -y
	apt install vlc -y
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	apt install ./google-chrome-stable_current_amd64.deb -y
	rm google-chrome-stable_current_amd64.deb

	#grub-customizer 
	add-apt-repository ppa:danielrichter2007/grub-customizer -y
	apt update
	apt install grub-customizer -y

	#Custom grub
	chown -R root:root ubuntu
	if [[ ! -d /boot/grub/themes ]]
	then
		mkdir /boot/grub/themes
	fi
	mv ubuntu /boot/grub/themes

	chown root:root grub
	mv grub /etc/default
	update-grub

	#install vietnamese telex
	add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
	apt-get update
	apt-get install ibus ibus-bamboo --install-recommends -y
	ibus restart

	# Set ibus-bamboo as default keyboard

	env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"


	#setup nerdfont for nvim-display
	chown $current_user:$current_user AgaveNerdFont-Regular.ttf
	if [  ! -d /home/$current_user/.local/share/fonts ]
	then
		mkdir /home/$current_user/.local/share/fonts
	fi
	chown $current_user:$current_user /home/$current_user/.local/share/fonts

	mv AgaveNerdFont-Regular.ttf /home/$current_user/.local/share/fonts
	fc-cache -f -v

fi

#install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-/home/'$current_user'/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
chown -R $current_user:$current_user /home/$current_user/.local/share/nvim

#add auto use python virtual environment on startup
echo '''
alias py_virtual="source /py_virtual/bin/activate"
if [[ $(whoami) =~ "root" ]]
then
    source /py_virtual/bin/activate
fi
''' >>/etc/bash.bashrc 

echo "source /py_virtual/bin/activate">>/home/$current_user/.bashrc

nvim=`realpath nvim`

#create folder and python virtual environment
if [ ! -d /py_virtual ]
then
	mkdir /py_virtual
	`python3 -m venv /py_virtual`
fi

#install python libraries
source /py_virtual/bin/activate
pip install -r requirements.txt
mv .pylintrc /home/$current_user/

#Check if have NVDIA GPU
echo -en "\a"
if [[ `lspci | grep VGA | grep NVIDIA` != '' ]]
then
	echo 'You have NVIDIA GPU,install tensorflow for GPU'
	sleep 5
	pip install tensorflow[and-cuda] #intstall tensorflow for gpu
else
	echo "You don't have NVIDIA GPU,install tensorflow for CPU"
	sleep 5
	pip install tensorflow #install tensorflow for cpu
fi

#Setup for neovim
if [ ! -d /home/$current_user/.config/nvim ]
then
	mv nvim /home/$current_user/.config/nvim
fi

#Install neovim plugins for current_user
su -c 'nvim --headless +"PlugInstall" +qa' $current_user

#Setup image background
if [[  ! -d /home/$current_user/Downloads/wallpaper ]]
then
	mkdir /home/$current_user/Downloads/wallpaper
fi
chown -R $current_user:$current_user /home/$current_user/Downloads/wallpaper
mv sad_cat.jpg /home/$current_user/Downloads/wallpaper
gsettings set org.gnome.desktop.background picture-uri "file:///home/$current_user/Downloads/wallpaper/sad_cat.jpg"

#Setup xfce4-terminal background
mv fire_cat.jpg /home/$current_user/Downloads/wallpaper #setup wallpaper for terminal

touch xfce4-terminal.xml

echo '''<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-terminal" version="1.0">
  <property name="background-mode" type="string" value="TERMINAL_BACKGROUND_IMAGE"/>
  <property name="background-image-shading" type="double" value="0.5"/>
  <property name="font-name" type="string" value="Agave Nerd Font Mono 12"/>
  <property name="shortcuts-no-menukey" type="bool" value="false"/>
  <property name="background-image-file" type="string" value="/home/'''$current_user'''/Downloads/wallpaper/fire_cat.jpg"/>
  <property name="background-image-style" type="string" value="TERMINAL_BACKGROUND_STYLE_FILLED"/>
</channel>
''' >>xfce4-terminal.xml
chown $current_user:$current_user xfce4-terminal.xml

mv xfce4-terminal.xml /home/$current_user/.config/xfce4/xfconf/xfce-perchannel-xml

apt update && apt upgrade -y
reboot
