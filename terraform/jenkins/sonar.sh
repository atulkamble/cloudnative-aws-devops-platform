#!/bin/bash

set -e

echo "===== Updating System ====="
sudo yum update -y

echo "===== Installing Dependencies ====="
sudo amazon-linux-extras install java-openjdk17 -y
sudo yum install wget unzip git -y

echo "===== Installing PostgreSQL 14 ====="
sudo amazon-linux-extras install postgresql14 -y
sudo yum install postgresql14 postgresql14-server -y

echo "===== Initializing PostgreSQL Database ====="
sudo /usr/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14

echo "===== Creating SonarQube PostgreSQL User & DB ====="
sudo -u postgres psql <<EOF
CREATE USER sonar WITH PASSWORD 'sonar123';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

echo "===== Tuning PostgreSQL ====="
PG_CONF="/var/lib/pgsql/14/data/postgresql.conf"
PG_HBA="/var/lib/pgsql/14/data/pg_hba.conf"

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" $PG_CONF
echo "host    all             all             0.0.0.0/0            md5" | sudo tee -a $PG_HBA

sudo systemctl restart postgresql-14

echo "===== Creating Sonar User ====="
sudo useradd -m -d /opt/sonarqube sonar || true

echo "===== Downloading SonarQube ====="
cd /tmp
SONAR_VERSION=10.4.0.87286
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip
unzip sonarqube-${SONAR_VERSION}.zip
sudo mv sonarqube-${SONAR_VERSION} /opt/sonarqube

echo "===== Setting Permissions ====="
sudo chown -R sonar:sonar /opt/sonarqube

echo "===== Configuring SonarQube ====="
sudo bash -c 'cat > /opt/sonarqube/conf/sonar.properties <<EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar123
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube

sonar.web.port=9000
EOF'

echo "===== Creating Systemd Service ====="
sudo bash -c 'cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=65536
LimitNPROC=4096
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

echo "===== Reloading Systemd ====="
sudo systemctl daemon-reload

echo "===== Starting SonarQube ====="
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

echo "===== SonarQube Installed Successfully ====="
echo "Access SonarQube at: http://YOUR-EC2-PUBLIC-IP:9000"
echo "Default Login: admin / admin"
