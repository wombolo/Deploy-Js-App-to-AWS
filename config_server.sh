#!/bin/bash
source ./.env

# display current progress
current_progress(){
  echo ""
  echo -e "\033[0;32m ========== ${1} =========== \033[0m"
}

#Installing Node, Nginx, npm
install_software(){
  current_progress "Installing Node, Nginx, npm"
  sudo apt-get update

  sudo apt-get install -y nginx
  sudo systemctl restart nginx.service

  curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh 
  sudo apt-get install -y nodejs
  sudo npm install -g npm@latest
}

#Install PM2 & run app in background
run_app_in_background() {
start_script='
  {
    "apps": [
      {
        "name": "authors_haven",
        "script": "npm",
        "args": "run start"
      }
    ]
  }'
  current_progress "Install PM2 to run app in background"
  sudo npm install pm2 -g

  echo "${start_script}" > ./start_script.config.json
  pm2 start start_script.config.json
}

#Download repo, install dependencies & configure node app
setup_application(){
  current_progress "Downloading repo & installing dependencies"

  git clone ${GitHub_Repo} authors_haven/
  cd authors_haven/

  #JSapp .env
  app_env="API_BASE_URL = https://krypton-ah-stage.herokuapp.com/api/v1
  BASE_URL_CB = https://krypton-ah-fe-stage.herokuapp.com
  FACEBOOK_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/facebook
  GOOGLE_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/google
  LINKEDIN_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/linkedin
  TWITTER_URL = https://krypton-ah-stage.herokuapp.com/api/v1/auth/
  BASE_URL_CB = https://krypton-ah-fe-stage.herokuapp.com"

  touch .env && echo "${app_env}" > .env

   npm install
   npm run-script build

   #Run application in background
   run_app_in_background
}

#Configuring Nginx
configure_nginx(){
  current_progress "Configuring Nginx"

cat <<EOF > ./authorshavenconf
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    index index.html index.htm index.nginx-debian.html;
    server_name ${Domain} ${www_Domain};

    location / {
            proxy_pass http://127.0.0.1:5000;
            try_files $uri $uri/ =404;
    }
}
EOF

  sudo cp authorshavenconf /etc/nginx/sites-available/authorshavenconf

  sudo ln -s /etc/nginx/sites-available/authorshavenconf /etc/nginx/sites-enabled/authorshavenconf
  sudo rm -r /etc/nginx/sites-enabled/default

  sudo systemctl restart nginx.service
}

#Configuring SSL Certificate
configure_SSL() {
  current_progress "Now Configuring SSL Certificate"
  sudo apt-get update
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:certbot/certbot -y
  sudo apt-get update
  sudo apt-get install certbot python-certbot-nginx -y
  sudo certbot --nginx  -d ${Domain} -d ${www_Domain} -m ${Email} --agree-tos --non-interactive
}

#Main function
main(){
   install_software
   setup_application
   configure_nginx
   configure_SSL
}

# Check if environment variables are set
if [[ $Domain && $www_Domain && $GitHub_Repo && $Email  ]]; then
    main
 else
    echo -e "\033[0;31m ========== Please set up .env variables =========== \033[0m"
fi
