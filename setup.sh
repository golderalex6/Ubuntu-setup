#!usr/bin/bash

#Require login as root user
if [[ ! $(whoami) =~ 'root' ]]
then
	echo 'You are not root !!'
	exit
fi

#require current_username
echo 'Enter your username:'
read current_user

if [ ! -d /home/$current_user/ ]
then
	echo 'Your username does not exist ! you need to rerun the file.'
	exit
fi

#require in the same dir as the scripts
current_working_dir=`pwd`
__file__=`realpath $BASH_SOURCE`
file_dir=`dirname $__file__`

echo "file dir :" $file_dir 
echo "current working dir :" $current_working_dir 
if [[ $current_working_dir != $file_dir ]]
then
	echo "You are not in the same folder of the file . Please go back !"
	exit
fi


#install some useful packages
apt install sqlite3 -y
apt install tree -y
apt install keychain -y
apt install wget -y
apt install curl -y
apt install neovim -y
apt install python3-venv -y
apt install apache2 -y
apt install openssh-server -y
apt install screen -y
apt install git -y
apt install silversearcher-ag -y

#check if using gui or not to install packges that support gui
if [[ ! -z `type Xorg` ]]
then

	apt install okular -y
	apt install vlc -y
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	apt install ./google-chrome-stable_current_amd64.deb -y
	rm google-chrome-stable_current_amd64.deb

	#grub-customizer 
	add-apt-repository ppa:danielrichter2007/grub-customizer
	apt update
	apt install grub-customizer -y

	#install vietnamese telex
	add-apt-repository ppa:bamboo-engine/ibus-bamboo
	apt-get update
	apt-get install ibus ibus-bamboo --install-recommends -y
	ibus restart

	# Set ibus-bamboo as default keyboard

	env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"


	#setup nerdfont for nvim-display
	curl -L -o AgaveNerdFont-Regular.ttf https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf
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
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#add auto use python virtual environment on startup
echo 'alias py_virtual="source /py_virtual/bin/activate"'>>/etc/bash.bashrc
echo "if [[ \$(whoami) =~ 'root' ]]">>/etc/bash.bashrc
echo "then">>/etc/bash.bashrc 
echo "    source /py_virtual/bin/activate">>/etc/bash.bashrc 
echo "fi">>/etc/bash.bashrc 

echo "source /py_virtual/bin/activate">>/home/$current_user/.bashrc

nvim=`realpath nvim`

#create folder and python virtual environment
if [ ! -d /py_virtual ]
then
	mkdir /py_virtual
	`python3 -m venv /py_virtual`
fi
source /py_virtual/bin/activate

if [ ! -d /home/$current_user/.config/nvim ]
then
	mv nvim /home/$current_user/.config/nvim
fi


