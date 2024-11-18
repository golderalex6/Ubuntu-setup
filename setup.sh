#!usr/bin/bash

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
apt install silversearcher-ag

gui_check=`type Xorg`
if [[ ! $gui_check =~ '' ]]
then
	apt install okular
	apt install vlc
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	apt install ./google-chrome-stable_current_amd64.deb
	rm google-chrome-stable_current_amd64.deb
	apt install grub-customizer
fi

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


if [ ! -d '/py_virtual' ]
then
	mkdir /py_virtual
	`python3 -m venv /py_virtual`
fi

echo 'alias py_virtual="source /py_virtual/bin/activate"'>>/etc/bash.bashrc
echo "if [[ \$(whoami) =~ 'root' ]]">>/etc/bash.bashrc
echo "then">>/etc/bash.bashrc 
echo "    source /py_virtual/bin/activate">>/etc/bash.bashrc 
echo "fi">>/etc/bash.bashrc 

echo 'Enter your username'
read current

ssh=`realpath .ssh`
nvim=`realpath nvim`

if [ -d /home/$current/ ]
then
	echo "source /py_virtual/bin/activate">>/home/$current/.bashrc
	cp -r $ssh /home/$current/
	cp -r $nvim /home/$current/.config/
else
	echo 'Your username does not exist !you need to rerun the file.'
fi
