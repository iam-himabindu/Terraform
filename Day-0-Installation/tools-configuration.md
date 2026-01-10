# DevOps Toolchain Setup on Amazon Linux (Single Script)

This guide provides a **single bootstrap script** to install and configure a complete **DevOps & CI/CD toolchain** on an Amazon Linux EC2 instance.



## 📌 Prerequisites
- Amazon Linux 2 / Amazon Linux 2023
- EC2 instance with sudo access
- Internet access
- Recommended instance: `t3.medium` or higher



## 🚀 One-Step Installation Script

```bash
#!/bin/bash

# ---------------- System Update ----------------
sudo yum update -y

# ---------------- Git ----------------
sudo yum install git -y

# ---------------- Java (Jenkins Dependency) ----------------
sudo yum install java-17-amazon-corretto.x86_64 -y

# ---------------- Jenkins ----------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# ---------------- Terraform ----------------
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform -y

# ---------------- Maven ----------------
sudo yum install maven -y

# ---------------- kubectl ----------------
sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# ---------------- eksctl ----------------
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

# ---------------- Trivy ----------------
sudo rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.48.3/trivy_0.48.3_Linux-64bit.rpm

# ---------------- SonarQube (RPM) ----------------
sudo yum install -y wget nfs-utils
sudo wget -O /etc/yum.repos.d/sonar.repo http://downloads.sourceforge.net/project/sonar-pkg/rpm/sonar.repo
sudo yum install sonar -y

# ---------------- JFrog Artifactory OSS ----------------
sudo wget https://releases.jfrog.io/artifactory/artifactory-rpms/artifactory-rpms.repo -O jfrog-artifactory-rpms.repo
sudo mv jfrog-artifactory-rpms.repo /etc/yum.repos.d/
sudo yum update -y
sudo yum install jfrog-artifactory-oss -y
sudo systemctl start artifactory.service

# ---------------- Docker ----------------
sudo yum install docker -y
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock
sudo systemctl start docker

# ---------------- SonarQube & Tomcat (Docker) ----------------
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
docker run -d --name tomcat -p 8089:8080 tomcat:lts-community

# ---------------- Terraformer ----------------
export PROVIDER=all
curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '\"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer
```



## 🔓 Required Security Group Ports

| Service | Port |
|------|------|
| Jenkins | 8080 |
| SonarQube | 9000 |
| JFrog Artifactory | 8081 |
| Tomcat | 8089 |



## 🛠️ Tools Installed

- Git
- Java 17 (Amazon Corretto)
- Jenkins
- Terraform
- Maven
- kubectl
- eksctl
- Trivy
- SonarQube
- JFrog Artifactory OSS
- Docker
- Terraformer



## ✅ Notes
- Run this script as **root or sudo user**
- Jenkins initial password:  
  `/var/lib/jenkins/secrets/initialAdminPassword`
- Docker permissions require **re-login** to take effect


