# # Deploy-Js-App-to-AWS
- Output 2.1 - Deploy Js App to AWS with NGINX as reverse proxy server
- Full video description available here: [Google Drive](https://drive.google.com/open?id=1zncIc65t7dyZ8pPjuBk7ZJssEgvSBoPQ)

- On succesful creation of AWS account, select & launch an EC2 instance
- Launch the terminal and connect to that instance via ssh i.e ssh -i "config.pem" ubuntu@1.2.3.4
- Clone the repository with the command git clone https://github.com/wombolo/Output-2.1-Deploy-Js-App-to-AWS
change directory into the repo folder
- Create a .env file, copy the content of the .env.sample and fill all variables
- Run the script with the command sudo ./config_server.sh
- Register and Create a domain of your choice with any provider. Such as Godaddy, Freenom, etc.

- After obtaining a domain from the provider, fill the Nameserver configuration to point to Route53's DNS servers, which are available on Route53. e.g. `NS-1504.AWSDNS-60.ORG`, etc

- Select Route53 from services and create an hosted zone, and also create a record set with this [tutorial](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-ec2-instance.html)

- Then create a new record for `A record` on Route53 to point to the Public IPv4 of your EC2 instance
- Now you should be able to access the app via a browser with the domain chosen
