#install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"'>>/home/$USER/.bashrc

#install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-/home/'$USER'/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


#Setup for neovim
if [ ! -d /home/$USER/.config/nvim ]
then
	mkdir /home/$USER/.config/nvim
	mv * /home/$USER/.config/nvim
fi

#Install neovim plugins for current_user
nvim --headless +"PlugInstall" +qa

sudo apt install nodejs npm git -y #required packages

sudo apt install silversearcher-ag -y #for searching text in project
apt install ripgrep

sudo npm install -g pyright #python lsp
sudo npm install -g typescript-language-server #for js,ts lsp
sudo npm install -g vscode-langservers-extracted #for html,css lsp
sudo npm install -g bash-language-server #for bash lsp
sudo npm install -g sql-language-server #for mysql,sqlite3 lsp
sudo npm install -g @microsoft/compose-language-service #for docker-compose lsp
sudo npm install -g dockerfile-language-server-nodejs #for dockerfile lsp

pip install -U nginx-language-server #for nginx lsp
pip install ruff #for linter and formatter



sudo npm install -g jshint #for js,ts linting

#addition package
pip install pynvim

