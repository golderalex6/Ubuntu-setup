<h1 align="center">Linux setup</h1>

<p align="center">
    <strong>This project automates post-installation setup for Ubuntu, including package installation, font and language configuration, GRUB bootloader setup, Python virtual environment creation, and library installation. It streamlines system preparation for development and personal use.</strong>
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
    <pre><code>git clone https://github.com/your-username/your-project-name.git</code></pre>
    </li>
</ul>

<h2 id="usage">📈<ins>Usage</ins></h2>
<ul>
<li>
<pre><code>sudo su
bash setup.sh
</code></pre>
</li>

</ul>

<h2 id="usage">⚙️  <ins>Config</ins></h2>
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
    <p><b>Validate username : </b>Prompts the user for a username and verifies that a home directory exists for it. If the username is invalid, the script exits.</p>
<pre><code>echo 'Enter your username:'
read current_user

if [ ! -d /home/$current_user/ ]
then
    echo 'Your username does not exist ! you need to rerun the file.'
	exit
fi</code></pre>
</li>

<li>
    <p><b>Install useful packages : </b>Installs a list of essential utilities and development tools such as sqlite3, neovim, git, and openssh-server</p>
<pre><code>
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
</code></pre>
</li>

<li>
    <p><b>Check for GUI environment : </b>Checks if the system is running a graphical environment (Xorg). If detected, additional GUI-related software is installed.</p>
<pre><code>
if [[ ! -z `type Xorg` ]]
then
	# GUI-specific installations here
fi
</code></pre>
</li>

</ol>

<h2 id="contact">☎️<ins>Contact</ins></h2>
<p>
    Your Name - <a href="mailto:golderalex6@gmail.com">golderalex6@gmail.com</a><br>
    Project Link: <a href="https://github.com/your-username/your-project-name">https://github.com/your-username/your-project-name</a>
</p>

<hr />
