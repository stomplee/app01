## Technical Test Instruction Guide

1. Create a VPC.  Call it **bluecoveapp01vpc**, set the CIDR block to **10.0.0.0/16**
2. Create a subnet called "bluecoveapp01subnetA" , assign it to the new vpc, set the availability zone to us-east-1a and set the IPv4 CIDR block to 10.0.1.0/24.  Select the new subnet and under subnet actions select modify auto-assign ip settings and enable auto-assign public IP
3. Create a subnet called "bluecoveapp01subnetB" , assign it to the new vpc, set the availability zone to us-east-1b and set the IPv4 CIDR block to 10.0.2.0/24.  Select the new subnet and under subnet actions select modify auto-assign ip settings and enable auto-assign public IP
Create an internet gateway called "bluecoveapp01igw" and attach it to the "bluecove-app01-vpc" VPC
Create a route table called "bluecoveapp01route" and associate to the "bluecoveapp01vpc" VPC, associate the subnets created in steps 2 and 3 to the "bluecoveapp01route" routing table and add a new route to it of 0.0.0.0/0 target "bluecoveapp01igw"
Create a security group called "bluecoveapp01sg" , assign it to "bluecoveapp01vpc" and add inbound rules for 22 from MyIP, HTTP from anywhere and HTTPS from anywhere
Once the "bluecoveapp01sg" security group has been created go back and add an additional inbound rule for 3306 MYSQL/Aurora from the "bluecoveapp01sg" security group itself
Launch a new EC2 instance, choose Ubuntu 16.04 LTS x64 as the AMI, choose t2.micro, set to use "bluecoveapp01vpc" as its VPC, choose "bluecoveapp01subnetA" for a subnet and under Advanced Details enter the script below and assign a tag of Name=bluecoveapp01server1 and associate with the gkyle ssh key
#!/bin/bash
mkdir -p /git
git clone https://github.com/stomplee/app01 /git
sh /git/install.sh
Repeat step 8 except use the other subnet, "bluecoveapp01subnetB", everything else remains the same
Create a classic Load Balancer, name it "bluecoveapp01elb", associate with "bluecoveapp01vpc" VPC, set the load balancer protocol to https, the lb port to 443, the instance protocol to https and the instance port to 443, associate it with both subnets, choose the "bluecoveapp01sg" security group, and upload a new SSL cert taking the required values from apache.key and apache.crt located in https://github.com/stomplee/app01/ call the cert "bluecoveapp01cert"
Set the health check to use HTTPS as a ping protocol with a ping port of 443 and use the default ping path.  Set the response timeout to 5s, the interval to 10s and lower the healthy threshold to 2
Associate it with both EC2 instances created previously, tag it as "Name=bluecoveapp01elb"
At this point you need to wait a while for the ELB to figure out that the instances behind it are healthy, and also some time for the DNS record for the ELB to propogate.  I've had it take up to 10 minutes, but it does work eventually.
You should now be able to browse to https://<elb dns name>/test.php and should see a result of "Default database is testdb" if everything is working correctly.  I have verified that the ELB works correctly, but you can see for yourself by tailing  /var/log/apache2/access.log on the two instances
