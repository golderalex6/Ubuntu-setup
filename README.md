<h1 align="center">Ubuntu setup</h1>

<p align="center">
    <strong>This project automates post-installation setup for Ubuntu, including package installation, font and language configuration, grub bootloader setup, Python virtual environment creation, and library installation. It streamlines system preparation for development and personal use.</strong>
    <br />
    <br />
    <a href="#installation">Installation</a> •
    <a href="#usage">Usage</a> •
    <a href="#confic">Config</a> •
    <a href="#logic">Logic</a> •
    <a href="#contact">Contact</a> •
</p>

<hr />

<h2 id="installation">📁<ins>Installation</ins></h2>
<pre><code>git clone https://github.com/golderalex6/Ubuntu-setup.git</code></pre>

<h2 id="usage">📈<ins>Usage</ins></h2>
<pre><code>bash setup.sh
</code></pre>

<h2 id="confic">⚙️  <ins>Config</ins></h2>
<ul>
    <li>To set custom terminal and screen backgrounds:
        <ul>
            <li>Take your photo and rename it to terminal_background.jpg to automatically set it as the terminal background.</li>
            <li>Rename it to screen_background.jpg to set it as your wallpaper.</li>
            <li>Place both files in the main folder (the same folder as setup.sh).</li>
        </ul>
    </li>
    <li>You can modify the Python libraries to be installed in requirements.txt by adding, removing, or updating them.</li>
    <li>You can only modify the apt packages to be installed on setup.sh,on <a href="#install_core"><ins>Install core utilities </ins></a> part.</li>
    <li>All Neovim configurations will be stored in the nvim folder.</li>
    <li>
        For GRUB:
        <ul>
            <li>Change the GRUB theme by modifying the ubuntu folder.</li>
            <li>Modify the GRUB workflow by editing the grub file. <b><ins>(Be cautious when editing these files or folders if you are not fully familiar with how GRUB works.)</ins></b></li>
        </ul>
    </li>
    <li>
        For font settings:
        <ul>
            <li>Visit <a href='https://github.com/ryanoasis/nerd-fonts'><ins>NerdFont</ins></a> to choose your preferred font.</li>
            <li>Place the installed font in the same folder as setup.sh.</li>
        </ul>
    </li>
</ul>

<h2 id="logic">📚<ins>Logic</ins></h2>
<ol>
<li>
    <p><b>Root user check : </b>This shell script checks if the current user is root by comparing the $USER variable to 'root'. If true, it prompts the user to log out and exits the script to prevent further execution.</p>
<pre><code>if [[ ! $(whoami) =~ 'root' ]]
then
    echo 'You are not root !!'
    exit
fi</code></pre>
</li>


<li>
    <p><b>Verify script location : </b>The script verifies that it is being executed from its directory by comparing the current working directory to the directory of the script itself. If the directories do not match, the script exits, prompting the user to navigate to the correct folder.</p>
<pre><code>current_working_dir=`pwd`
__file__=`realpath $BASH_SOURCE`
file_dir=`dirname $__file__`
if [[ $current_working_dir != $file_dir ]]
then
    echo "You are not in the same folder of the file . Please go back !"
    exit
fi</code></pre>
</li>

<li>
    <p id='install_core'><b>Install core utilities : </b>This section installs a variety of essential utilities for the system, including SQLite, tree, wget, curl, and others, such as tools for managing Python virtual environments and server utilities like Apache and SSH. It also performs a system update to ensure the latest package versions are installed, preventing conflicts between dependencies.</p>
<pre><code>sudo apt install sqlite3 -y
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
sudo apt install libxcb-cursor-dev -y #for matplotlib</code></pre>
</li>

<li>
    <p><b> : </b>Checks if the system is running a graphical environment (Xorg). If detected, additional GUI-related software is installed.</p>
<pre><code>if [[ ! -z `type Xorg` ]]
then
    # GUI-specific installations here
fi
</code></pre>
</li>

<li>
    <p><b>Inside GUI environment block:</b></p>
    <ol>
        <li>
            <p><b>Install and Set XFCE4 Terminal as Default : </b>This script installs the xfce4-terminal package and sets it as the default terminal emulator by updating the system alternatives.</p>        
<pre><code>
sudo apt install xfce4-terminal -y
sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
</code></pre>
        </li>
        <li>
        <p><b>Install multimedia and browser tools : </b>Installs tools like Okular (PDF reader), VLC (media player), and Google Chrome.</p>
<pre><code>
sudo apt install okular -y
sudo apt install vlc -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb
</code></pre>
        </li>
        <li>
        <p><b>Install grub-customizer : </b>Adds a PPA and installs grub-customizer for customizing the bootloader.</p>
<pre><code>
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
sudo apt update
sudo apt install grub-customizer -y
</code></pre>
        </li>
        <li>
        <p><b>Custom grub : </b>Customizes grub by ensuring proper ownership, setting up a custom theme in /boot/grub/themes, and replacing the default grub configuration file in /etc/default with a custom one.</p>
<pre><code>
sudo chown -R root:root ubuntu
if [[ ! -d /boot/grub/themes ]]
then
    sudo mkdir /boot/grub/themes
fi
sudo mv ubuntu /boot/grub/themes
sudo chown root:root grub
sudo mv grub /etc/default
sudo update-grub
</code></pre>
</li>
        <li>
        <p><b>Install Vietnamese keyboard (IBUS Bamboo) : </b>Adds a repository for ibus-bamboo (Vietnamese input) and sets it as the default input method.</p>
<pre><code>
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install ibus ibus-bamboo --install-recommends -y
ibus restart
# Set ibus-bamboo as default keyboard
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
</code></pre>
    </li>
        <li>
        <p><b>Set up NerdFont for neovim : </b>Sets up a Nerd Font for Neovim by placing it in the user’s fonts directory, ensuring ownership, and updating the font cache.</p>
<pre><code>if [  ! -d /home/$USER/.local/share/fonts ]
then
    mkdir /home/$USER/.local/share/fonts
fi
mv AgaveNerdFontMono-Regular.ttf /home/$USER/.local/share/fonts
fc-cache -f -v
</code></pre>
    </li>
    <li>
    <p><b>Setup screen background : </b>This script creates a wallpaper directory in the user's Downloads folder if it doesn't already exist, moves the screen_background.jpg file into it, and sets it as the desktop background using GNOME's settings.</p>
<pre><code>if [[  ! -d /home/$USER/Downloads/wallpaper ]]
then
    mkdir /home/$USER/Downloads/wallpaper
fi
mv screen_background.jpg /home/$USER/Downloads/wallpaper
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Downloads/wallpaper/screen_background.jpg"
</code></pre>
    </li>
    <li>
    <p><b>Setup xfce4-terminal background : </b>Moves the terminal_background.jpg image to the user's Downloads/wallpaper directory, creates the necessary configuration directory for XFCE4 terminal settings if it doesn't exist, and then writes a custom configuration to set the terminal background image and other appearance settings, such as font and shading.</p>
<pre><code>
mv terminal_background.jpg /home/$USER/Downloads/wallpaper #setup wallpaper for terminal
if [[ ! -d  /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml ]]
then
    mkdir -p /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml 
fi
echo '''< xml version="1.0" encoding="UTF-8"?>
< channel name="xfce4-terminal" version="1.0">
    < property name="background-mode" type="string" value="TERMINAL_BACKGROUND_IMAGE"/>
    < property name="background-image-shading" type="double" value="0.5"/>
    < property name="font-name" type="string" value="Agave Nerd Font Mono 12"/>
    < property name="shortcuts-no-menukey" type="bool" value="false"/>
    < property name="background-image-file" type="string" value="/home/'''$USER'''/Downloads/wallpaper/terminal_background.jpg"/>
    < property name="background-image-style" type="string" value="TERMINAL_BACKGROUND_STYLE_FILLED"/>
< /channel>
''' >>/home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml #write setting to xfce4-terminal
</code></pre>
    </li>
    </ol>
</li>
<li>
    <p><b>Set up python virtual environment on startup : </b>Adds an alias and auto-activates a Python virtual environment when logging in as root or the specified user.</p>
<pre><code>sudo bash -c 'echo alias py_virtual=\"source /home/'$USER'/py_virtual/bin/activate\" >> /etc/bash.bashrc'
sudo bash -c 'echo if [[ \$\(whoami\) == \"root\" ]] >> /etc/bash.bashrc'
sudo bash -c 'echo then >> /etc/bash.bashrc '
sudo bash -c 'echo "    source /home/'$USER'/py_virtual/bin/activate" >> /etc/bash.bashrc'
sudo bash -c 'echo fi >> /etc/bash.bashrc'
echo 'source /home/'$USER'/py_virtual/bin/activate'>>/home/$USER/.bashrc
</code></pre>
</li>
<li>
    <p><b>Create and activate python virtual environment : </b>Creates a global Python virtual environment (/home/$USER/py_virtual) and installs dependencies listed in requirements.txt.</p>
<pre><code>if [ ! -d /home/$USER/py_virtual ]
then
	mkdir /home/$USER/py_virtual
	$(python3 -m venv /home/$USER/py_virtual)
fi</code></pre>
    </li>
<li>
    <p><b>TensorFlow Installation Based on GPU Detection : </b>Checks for an NVIDIA GPU using the lspci command. If found, it installs TensorFlow with GPU support; otherwise, it installs the CPU-only version.</p>
<pre><code>echo -en "\a"
if [[ `lspci | grep VGA | grep NVIDIA` != '' ]]
then
	echo 'You have NVIDIA GPU,install tensorflow for GPU'
	sleep 5
	pip install tensorflow[and-cuda] #intstall tensorflow for gpu
else
	echo "You don't have NVIDIA GPU,install tensorflow for CPU"
	sleep 5
	pip install tensorflow #install tensorflow for cpu
fi</code></pre>
    </li>
<li>
    <p><b>Move .pylint configuration : </b>Moves the .pylintrc file (Python linter configuration) to the user's home directory.</p>
<pre><code>mv .pylintrc /home/$current_user/</code></pre>
</li>
    <li>
    <p><b>Set up neovim configuration : </b>installs vim-plug, a plugin manager for Neovim, by downloading the plug.vim file to the appropriate directory. It then checks if the Neovim configuration directory exists, and if not, moves a predefined nvim directory into the correct location. Finally, it installs Neovim plugins using the PlugInstall command in headless mode.</p>
<pre><code>sh -c 'curl -fLo "${XDG_DATA_HOME:-/home/'$USER'/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if [[ ! -d /home/$USER/.config/nvim ]]
then
    mv nvim /home/$USER/.config/nvim
fi
</code></pre>
</li>
    <li>
    <p><b>Update again and reboot : </b>install lastest version of all packages and then reboots to apply changes.</p>
<pre><code>sudo apt update && sudo apt upgrade -y
reboot
</code></pre>
</li>

</ol>

<h2 id="contact">☎️<ins>Contact</ins></h2>
<p>
    My email - <a href="mailto:golderalex6@gmail.com">golderalex6@gmail.com</a><br>
    Project Link:<a href="https://github.com/golderalex6/Ubuntu-setup">https://github.com/golderalex6/Ubuntu-setup</a>
</p>

<hr />
