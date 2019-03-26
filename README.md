# # Deploy Js App to AWS
Deploy Js app to AWS using NGINX as reverse proxy server.
Full video description available on [Google Drive](https://drive.google.com/open?id=1zncIc65t7dyZ8pPjuBk7ZJssEgvSBoPQ)

## Getting Started
These instructions will allow you setup a javaScript app in the cloud using AWS-EC2 for development and testing purposes. 
This guide assumes that you already have an AWS account and can easily follow the steps below however if you do not already have an account, go to [https://aws.amazon.com](https://aws.amazon.com) .

### Setup EC2 Instance
A step by step series of examples that tell you how to get it running

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.18.38%20AM.png)
-Select EC2

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.20.30%20AM.png)
-Click Launch Instance 

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.21.07%20AM.png)
-Choose any AMI of your choice. But we’ll focus on Ubuntu 16.04 Image

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.22.28%20AM.png)
 -Select any instance type of your choice

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.25.26%20AM.png)
-Leave these settings as default 


![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.28.18%20AM.png)
-Leave these settings as default 

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.29.10%20AM.png)
-Add tags as needed

 
![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.30.26%20AM.png)
-Add rules as desired. Kindly note that it isn’t recommended to set SSH Source to 0.0.0.0 in a critical/ production environment to prevent the instance accessible by anyone on the internet.

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.33.39%20AM.png)
-Review settings and launch.


### Setup Route53 & Nameservers

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.41.08%20AM.png)
-Under services, click Route53.

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.42.52%20AM.png)
-Click on Hosted zones

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.43.24%20AM.png)
-Click Create Hosted Zone, then fill your domain. E.g. example.com

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.43.43%20AM.png)
-Click on the record of type `NS` then copy all the values of nameservers.

![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.44.38%20AM.png)
-On your domain name provider, fill the values copied from the above and paste them in the nameservers settings field of your domain provider, such as Godaddy or Freenom.


![](%23%20Deploy%20Js%20App%20to%20AWS/Screenshot%202019-03-26%20at%2011.45.58%20AM.png)
-Back to Route53 page, create a record set that will set the A records for your domain as shown in the above picture. Paste the value of your EC2 instance’s public IPv4 address in the value field.
Repeat this step  once more, this time filling the ‘name’ field with `www` only.

### Cloning the application from Github and initialising
* Launch a terminal and connect to the EC2 instance via ssh i.e `ssh -i “PATH_TO_CONFIG.PEM” ubuntu@1.2.3.4`

* Clone the repository with the command git clone [https://github.com/wombolo/Output-2.1-Deploy-Js-App-to-AWS](https://github.com/wombolo/Output-2.1-Deploy-Js-App-to-AWS) .

* Then change directory into the repo folder

* Create a .env file, copy the content of the .env.sample and fill all variables
* Make the script executable by: `chmod u+x config_server.sh`

* Run the script with the command `sudo ./config_server.sh`. Watch the script perform its magic and spawn the application.
* Access the app on the specified domain name of your choosing.


## Acknowledgments
* My DevOps family
