#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto -y

sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo docker run --name sonar -d -p 9000:9000 sonarqube:lts-community