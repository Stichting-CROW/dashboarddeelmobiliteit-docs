
. ~/.bashrc

# echo "Install NVM"
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#echo "Download source code frontend"
#wget -O dashboard-frontend.zip https://github.com/Stichting-CROW/dashboarddeelmobiliteit-app/archive/refs/heads/main.zip
unzip dashboard-frontend.zip
cd dashboarddeelmobiliteit-app-main

nvm install 18
nvm use 18
npm install
npm run build

