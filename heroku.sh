# Dev Heroku
wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz
tar -xvzf heroku.tar.gz
mkdir -p /usr/local/lib /usr/local/bin
sudo mv heroku-cli-v6.* /usr/local/lib/heroku
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku
