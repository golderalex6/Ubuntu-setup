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

#install some useful packages
sudo apt install sqlite3 -y
sudo apt install tree -y
sudo apt install keychain -y
sudo apt install wget -y
sudo apt install curl -y
sudo apt install neovim -y

sudo apt update && sudo apt upgrade -y #check package update to prevent conflict

sudo apt install python3-venv -y
sudo apt install apache2 -y
sudo apt install openssh-server -y
sudo apt install screen -y
sudo apt install git -y
sudo apt install silversearcher-ag -y
sudo apt install libxcb-cursor-dev -y #for matplotlib

#install for js and nvim
sudo apt install node npm

#check if using gui or not to install packges that support gui
if [[ ! -z `type Xorg` ]]
then
	#install xfce4
	sudo apt install xfce4-terminal -y
	sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper #Set xfce4 as default terminal

	#install media
	sudo apt install okular -y
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


#add auto use python virtual environment on startup
sudo bash -c 'echo alias py_virtual=\"source /home/'$USER'/py_virtual/bin/activate\" >> /etc/bash.bashrc'
sudo bash -c 'echo if [[ \$\(whoami\) == \"root\" ]] >> /etc/bash.bashrc'
sudo bash -c 'echo then >> /etc/bash.bashrc '
sudo bash -c 'echo "    source /home/'$USER'/py_virtual/bin/activate" >> /etc/bash.bashrc'
sudo bash -c 'echo fi >> /etc/bash.bashrc'


echo 'source /home/'$USER'/py_virtual/bin/activate'>>/home/$USER/.bashrc

#create folder and python virtual environment
if [ ! -d /home/$USER/py_virtual ]
then
	mkdir /home/$USER/py_virtual
	$(python3 -m venv /home/$USER/py_virtual)
fi

#install python libraries
source /home/$USER/py_virtual/bin/activate
pip install -r requirements.txt
mv .pylintrc /home/$USER/

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

#install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-/home/'$USER'/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#Setup for neovim
if [ ! -d /home/$USER/.config/nvim ]
then
	mv nvim /home/$USER/.config/nvim
fi

#Install neovim plugins for current_user
nvim --headless +"PlugInstall" +qa

sudo apt update && sudo apt upgrade -y
reboot
