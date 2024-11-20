<h1 align="center">Ubuntu setup</h1>

<p align="center">
    <strong>This project automates post-installation setup for Ubuntu, including package installation, font and language configuration, grub bootloader setup, Python virtual environment creation, and library installation. It streamlines system preparation for development and personal use.</strong>
    <br />
    <br />
    <a href="#installation">Installation</a> •
    <a href="#usage">Usage</a> •
    <a href="#config">Config</a> •
    <a href="#contact">Contact</a> •
</p>

<hr />

<h2 id="installation">📁<ins>Installation</ins></h2>
<ul>
    <li>Step 1: Clone the repo.
    <pre><code>git clone https://github.com/golderalex6/Ubuntu-setup.git</code></pre>
    </li>
</ul>

<h2 id="usage">📈<ins>Usage</ins></h2>
<pre><code>sudo su
bash setup.sh
</code></pre>


<h2 id="config">⚙️  <ins>Config</ins></h2>
<ol>
<li>
    <p><b>Require login as root : </b>Ensures that the script is executed with root privileges. If the user is not logged in as root, it exits with a message.</p>
<pre><code>if [[ ! $(whoami) =~ 'root' ]]
then
    echo 'You are not root !!'
    exit
fi</code></pre>
</li>


<li>
    <p><b>Verify script location : </b>Checks if the script is being run from its own directory. If not, it prompts the user to move to the script's directory and exits.</p>
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
    <p><b>Get current user : </b>Retrieves the username of the currently logged-in user.</p>
<pre><code>current_user=`who | awk '{print $1}' | head -n 1`
</code></pre>
</li>

<li>
    <p><b>Install useful packages : </b>Installs a list of essential utilities and development tools such as sqlite3, neovim, git, and openssh-server</p>
<pre><code>apt install sqlite3 -y
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
</code></pre>
</li>

<li>
    <p><b>Check for GUI environment : </b>Checks if the system is running a graphical environment (Xorg). If detected, additional GUI-related software is installed.</p>
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
        <p><b>Install multimedia and browser tools : </b>Installs tools like Okular (PDF reader), VLC (media player), and Google Chrome.</p>
<pre><code>apt install okular -y
apt install vlc -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb
</code></pre>
        </li>
        <li>
        <p><b>Install grub-customizer : </b>Adds a PPA and installs grub-customizer for customizing the bootloader.</p>
<pre><code>add-apt-repository ppa:danielrichter2007/grub-customizer -y
apt update
apt install grub-customizer -y
</code></pre>
        </li>
        <li>
        <p><b>Custom grub : </b>Customizes grub by ensuring proper ownership, setting up a custom theme in /boot/grub/themes, and replacing the default grub configuration file in /etc/default with a custom one.</p>
<pre><code>chown -R root:root ubuntu
if [[ ! -d /boot/grub/themes ]]
then
    mkdir /boot/grub/themes
fi
mv ubuntu /boot/grub/themes

chown root:root grub
mv grub /etc/default
</code></pre>
</li>
        <li>
        <p><b>Install Vietnamese keyboard (IBUS Bamboo) : </b>Adds a repository for ibus-bamboo (Vietnamese input) and sets it as the default input method.</p>
<pre><code>add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
apt-get update
apt-get install ibus ibus-bamboo --install-recommends -y
ibus restart</code></pre>
    </li>
        <li>
        <p><b>Set up NerdFont for neovim : </b>Sets up a Nerd Font for Neovim by placing it in the user’s fonts directory, ensuring ownership, and updating the font cache.</p>
<pre><code>chown $current_user:$current_user AgaveNerdFont-Regular.ttf
if [  ! -d /home/$current_user/.local/share/fonts ]
then
    mkdir /home/$current_user/.local/share/fonts
fi
chown $current_user:$current_user /home/$current_user/.local/share/fonts
mv AgaveNerdFont-Regular.ttf /home/$current_user/.local/share/fonts
fc-cache -f -v
</code></pre>
    </li>
    </ol>
</li>
<li>
    <p><b>Inside GUI environment block : </b>Downloads and installs vim-plug, a plugin manager for Neovim.</p>
<pre><code>sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
</code></pre>
</li>
<li>
    <p><b>Set up python virtual environment on startup : </b>Adds an alias and auto-activates a Python virtual environment when logging in as root or the specified user.</p>
<pre><code>echo 'alias py_virtual="source /py_virtual/bin/activate"' >> /etc/bash.bashrc
echo "if [[ \$(whoami) =~ 'root' ]]" >> /etc/bash.bashrc
echo "then" >> /etc/bash.bashrc 
echo "    source /py_virtual/bin/activate" >> /etc/bash.bashrc 
echo "fi" >> /etc/bash.bashrc 

echo "source /py_virtual/bin/activate" >> /home/$current_user/.bashrc
</code></pre>
</li>
<li>
    <p><b>Create and activate python virtual environment : </b>Creates a global Python virtual environment (/py_virtual) and installs dependencies listed in requirements.txt.</p>
<pre><code>if [ ! -d /py_virtual ]
then
	mkdir /py_virtual
	`python3 -m venv /py_virtual`
fi

source /py_virtual/bin/activate
pip install -r requirements.txt
</code></pre>
    </li>
<li>
    <p><b>Move .pylint configuration : </b>Moves the .pylintrc file (Python linter configuration) to the user's home directory.</p>
<pre><code>mv .pylintrc /home/$current_user/</code></pre>
</li>
    <li>
    <p><b>Set up neovim configuration and restart: </b>Moves the Neovim configuration folder (nvim) to the user's .config directory.Installs Neovim plugins automatically using vim-plug.</p>
<pre><code>if [ ! -d /home/$current_user/.config/nvim ]
then
	mv nvim /home/$current_user/.config/nvim
fi

su -c 'nvim --headless +"PlugInstall" +qa' $current_user
</code></pre>
</li>
</ol>

<h2 id="contact">☎️<ins>Contact</ins></h2>
<p>
    Your Name - <a href="mailto:golderalex6@gmail.com">golderalex6@gmail.com</a><br>
    Project Link: <a href="https://github.com/golderalex6/Ubuntu-setup">https://github.com/golderalex6/Ubuntu-setup</a>
</p>

<hr />
