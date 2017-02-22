## Technical Test Instruction Guide

*This guide assumes you have provisioned an IAM user with the necessary permissions to create the resources below and have already configured an SSH key pair.*

*As it currently stands this configuration is woefully insecure and uses some very bad practices such as hardcoded passwords and storing private keys inside of github, but it tested to work and meets the requirements of the test as was given to me.*

1. Create a VPC in the **us-east-1** region, call it **bluecoveapp01vpc**, set the CIDR block to **10.0.0.0/16**.
2. Create a subnet called **bluecoveapp01subnetA**, assign it to **bluecoveapp01vpc**, set the availability zone to **us-east-1a** and set the IPv4 CIDR block to **10.0.1.0/24**.  Select the new subnet and under subnet actions select modify auto-assign ip settings and enable auto-assign public IP.
3. Create a subnet called **bluecoveapp01subnetB**, assign it to **bluecoveapp01vpc**, set the availability zone to **us-east-1b** and set the IPv4 CIDR block to **10.0.2.0/24**.  Select the new subnet and under subnet actions select modify auto-assign ip settings and enable auto-assign public IP.
4. Create an internet gateway called **bluecoveapp01igw** and attach it to **bluecoveapp01vpc**.
5. Create a route table called **bluecoveapp01route** and associate it with the **bluecoveapp01vpc**, associate the subnets **bluecoveapp01subnetA** and **bluecoveapp01subnetB** to this new route table and add a new route to it of **0.0.0.0/0** target **bluecoveapp01igw**.
6. Create a security group called **bluecoveapp01sg**, assign it to **bluecoveapp01vpc** and add inbound rules for **22 from MyIP**, **HTTP from Anywhere** and **HTTPS from Anywhere**.
7. Once the **bluecoveapp01sg** security group has been created go back and add an additional inbound rule for **3306 MYSQL/Aurora** from the **bluecoveapp01sg** security group itself.
8. Launch a new EC2 instance, choose **Ubuntu 16.04 LTS x64** as the AMI (ami-7c803d1c), choose **t2.micro**, set to use **bluecoveapp01vpc** as its' VPC, choose **bluecoveapp01subnetA** for a subnet and under Advanced Details enter the script below and assign a tag of **Name=bluecoveapp01server1** and associate with ssh key you wish to use ```
#!/bin/bash
mkdir -p /git
git clone https://github.com/stomplee/app01 /git
sh /git/install.sh
```
9. Repeat step 8 to create a second instance, except use the other subnet, **bluecoveapp01subnetB** and tag the new instance **Name=bluecoveapp01server2**
10. Create a classic Load Balancer, name it **bluecoveapp01elb**, associate with **bluecoveapp01vpc** VPC
11. Set the load balancer protocol to *HTTPS*, the load balancer port to **443**, the instance protocol to **HTTPS** and the instance port to **443**
12. Associate the new load balancer with **bluecoveapp01subnetA** and **bluecoveapp01subnetB**
12. Choose the **bluecoveapp01sg** security group
13. For the SSL certificate section choose to upload a new certificate and upload a new SSL cert with the following settings and naming the certficate **bluecoveapp01cert**:

# Private Key
```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDUHHN4WLZKjZWZ
llbcSbHngrl6SFzVUub0lqNV+PV93c0vpjj+jdBUCfLuoVI+75D4apoHn+Adwz4x
W609dh/gBtLooSZHMxagzVdW+NyQ/+LJH+00NnDCvNLmU2rX5kBbaPcta+Nlvd/N
vij/VRALgMCywr1F9YhQwJHosH0hks9n4wHQHFTftVWpH9BkgGpbwA1V8MtejmaC
x60eBMQ7eXrSGMwjHOLySwqluhexfySTVDfvW/wG82hkD4zJ0BX0TBmSTgi4YLSd
mnj5QkHuEQb9A/U406EB/mAVqTwUoimClrogWGXOwvl4GckZdCRPIj/qXiLy+RJ0
xmLlZoRZAgMBAAECggEBAKb9rzr0PK/9P+YnIkNUEaf+lx/akJuyJPozDmzFECED
2mLFLuHZrEY9fvC4ORQrb6rj4lhWWg+UgwZA8ucMdJPfS3SySnyLkCkRAM4MJzpQ
+q71X75XjfcCyddjnR5UvB47ST6NTf3vup80MvqycWtc9ljGUFUftS4+LaFQMXOX
voygzs0VJJCDTW4KuCfLQ9gE3AJZYZng9okd+p38hnzQY5ZwSAPojSh0FD8F4Fpt
15r/Y13qbKNhqLGyUbqgRPOMEEmWb8mVxrcZCvG3x5PuZv81g3RERKVEs7I6jdtR
jZZ56FFrMKUbdHpkZDKeU6ZN2qzrV5t5FeKlueziqLECgYEA7b4gISiP0tdFHeJl
5+wcEizEQlo6lQ+wfvVdHMvklpBgMlItHBz7KfwygsDXNz3iOXF69uNhGan+s4yk
ZRPe9ZroO9O8bwI6oOQTM36lEquxZ4GidnoYQ2mchmMBOfxEeqVHGvRq8i3WNfPi
Yy7sy7Uz8T1Q+CPudIfOq2ZJ+LMCgYEA5GZs3ZvMzWvt9KYT9enqtQJYZYMT7XSK
54WxhCzHYf82u8EOuW4k+Nea/42XPq5oQXDDaUTpJgzxeJc4VMHwafsI6RaiTerp
rsLglyI0RQMxOihXLnoapOVmWcrgsHoh+vSxVQIxWy0eurceTJ3jiqu+3oyh0Jy/
O6/Sj7D7nMMCgYAPGguqb4wrRXdjfZUhlVL3KJbS7C5ad6OrfOSMRrtfgQ5LRAMP
jRu7QATpX1yMasbrBTVdZ3Ysjiratu1ealO4YD2uRzXqC0c0HyjFFZ9gvz1GqOps
Ajd2WMgTlUhnqYmkDMmmga4lchnwVWylBj8OdZU2FsIE8StdhZ7wLlA2lwKBgAKl
KQecAVAzusrFjZ+geOZlw45RaU6rtdwekUK9ngWFhiXAg6IkI2t6W8Iv6puAO5be
bnTupmCZb8Z8wdtBb75aeOzyJSkP2mr6uM0nSUGvWseYpgHUyjA0s+3ASr/gejpE
0TTx1I6AxEVXT5OFlJgLiydaq5kV56USUTb2zsMvAoGAIdc4E4lzDKycfz8tfCCE
2PTgy+q0UG9Os3r9kwK8U0w5OuE6Du9JsqznqoyKT2AwIdvC5rBtt8AT4eRb6qdG
0f/fwAS5uUBNmLQXYu0EnGez3rVgC64oibzshAjvD+F8qW9QNbeETr5gMd6BvHWX
bwTzqzOWGQnQGNcRfgtnNDs=
-----END PRIVATE KEY-----
```

# Public Key Certificate
```
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAO9bFhFYC8ZtMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTcwMjIwMjIwNzUzWhcNMTgwMjIwMjIwNzUzWjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA1BxzeFi2So2VmZZW3Emx54K5ekhc1VLm9JajVfj1fd3NL6Y4/o3QVAny
7qFSPu+Q+GqaB5/gHcM+MVutPXYf4AbS6KEmRzMWoM1XVvjckP/iyR/tNDZwwrzS
5lNq1+ZAW2j3LWvjZb3fzb4o/1UQC4DAssK9RfWIUMCR6LB9IZLPZ+MB0BxU37VV
qR/QZIBqW8ANVfDLXo5mgsetHgTEO3l60hjMIxzi8ksKpboXsX8kk1Q371v8BvNo
ZA+MydAV9EwZkk4IuGC0nZp4+UJB7hEG/QP1ONOhAf5gFak8FKIpgpa6IFhlzsL5
eBnJGXQkTyI/6l4i8vkSdMZi5WaEWQIDAQABo1AwTjAdBgNVHQ4EFgQUv9EBbKl6
VNQpNfcilcvi9KwTJAgwHwYDVR0jBBgwFoAUv9EBbKl6VNQpNfcilcvi9KwTJAgw
DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEArNbG4Evy6WQ6DUtTMX/q
3M4UHmllubht+k4wd6K4fU6RjTshUzPNBzKxc1/IfeXRID136i+Y4jwx3Lnt1KI/
0kfdU/WbZNc8YiDo796Hk2Rl79Beg0q+J2ysIW1bdepRvt+ZqPJ8Et63l2p9sn+n
QisWTRbDyhncZyu1JnD3FH+y3XQvcmSZy2RvaJmABn3t4ZqJxypR7zF911hjf3zZ
0NutwIzbBC87P9HI8eGAevUPb9/3stx4Dt3n3aIjO9oY2MESWSMNC4GJnVIxgXaD
JNsJtlKqGyDplvkEB8U++5zPEG03LMX3G6iwwgEjFmqx85H16zAd6S1vJ5MBw6Ku
oQ==
-----END CERTIFICATE-----
```

14. Set the health check to use **HTTPS** as a ping protocol with a ping port of **443** and use the default ping path.  Set the response timeout to **5s**, the interval to **10s** and lower the healthy threshold to **2**
15. Associate the ELB with both EC2 instances created previously, tag the ELB as ***Name=bluecoveapp01elb***
16. At this point you need to wait a while for the ELB to figure out that the instances behind it are healthy, and also some time for the DNS record for the ELB to propogate.  I've had it take up to 10 minutes, but it does work eventually.
17. You should now be able to browse to https://<elb dns name>/test.php and should see a result of "Default database is testdb" if everything is working correctly.  I have verified that the ELB works correctly, but you can see for yourself by tailing  /var/log/apache2/access.log on the two instances
