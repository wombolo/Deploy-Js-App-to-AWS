#!/bin/bash
source .env

install_software(){
  sudo apt-get install -y nginx

  curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh 
  sudo apt-get install -y nodejs

  sudo npm install -g npm@latest
}

setup_application(){
  git clone ${GitHub_Repo} authors_haven/
  cd authors_haven/

  #app .env
  app_env="
  API_BASE_URL = https://krypton-ah-stage.herokuapp.com/api/v1
  BASE_URL_CB = https://krypton-ah-fe-stage.herokuapp.com
  FACEBOOK_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/facebook
  GOOGLE_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/google
  LINKEDIN_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/linkedin
  TWITTER_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/
  BASE_URL_CB = https://krypton-ah-fe-stage.herokuapp.com"

  touch .env && echo "${app_env}" > .env

   npm install
   npm run-script build

   npm run-script start &
}

configure_nginx(){
  config_server="
    server {
            listen 80 default_server;
            listen [::]:80 default_server;
            root /home/vagrant/authors_haven/dist;

            # Add index.php to the list if you are using PHP
            index index.html index.htm index.nginx-debian.html;

            server_name ${Domain} ${www_Domain};

            location / {
                    proxy_pass http://127.0.0.1:5000;

                    # First attempt to serve request as file, then
                    # as directory, then fall back to displaying a 404.
                    try_files $uri $uri/ =404;
            }
    }"
  
  echo "${config_server}" | sudo tee /etc/nginx/sites-available/authorshaven

  sudo ln -s /etc/nginx/sites-available/authorshaven /etc/nginx/sites-enabled/authorshaven
  sudo rm -r /etc/nginx/sites-enabled/default

  sudo systemctl restart nginx.service
}

configure_SSL() {
  echo "Now Configuring SSL Certificate"
  sudo apt-get update
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:certbot/certbot -y
  sudo apt-get update
  sudo apt-get install certbot python-certbot-nginx -y
  sudo certbot --nginx  -d ${Domain} -d ${www_Domain} -m ${Email} --agree-tos --non-interactive
}

main(){
   install_software
   setup_application
   configure_nginx
   configure_SSL
}

main
