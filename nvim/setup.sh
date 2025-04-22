sudo apt install nodejs npm git -y #required packages

sudo npm install -g pyright #python lsp
sudo npm install -g typescript-language-server #for js,ts lsp
sudo npm install -g vscode-langservers-extracted #for html,css lsp
sudo npm install -g dockerfile-language-server-nodejs #for docker lsp
sudo npm install -g bash-language-server #for bash lsp
sudo npm install -g sql-language-server #for mysql,sqlite3 lsp


sudo npm install -g jshint #for js,ts linting
pip install pylint #for python linting

#addition package
pip install pynvim

#install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

