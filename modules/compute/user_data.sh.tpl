#!/bin/bash
echo '[START] User data script'

# Install dependencies
sudo dnf update -y

# Configure CloudWatch Logs
echo '[START] Setting up CloudWatch Logs'
sudo dnf install -y amazon-cloudwatch-agent
sudo cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "root"
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/micropaye-${environment}.log",
                        "log_group_name": "/micropaye/${environment}/app",
                        "log_stream_name": "{instance_id}_access",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/micropaye-${environment}_error.log",
                        "log_group_name": "/micropaye/${environment}/app",
                        "log_stream_name": "{instance_id}_error",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    }
}
EOF

sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent
echo '[END] Setting up CloudWatch Logs'

# Fetch the application artifact
echo '[START] Downloading application'
mkdir -p /opt/micropaye
aws s3 cp s3://${artifact_bucket_name}/be-build/${application_artifact} /opt/micropaye/
unzip -o /opt/micropaye/${application_artifact} -d /opt/micropaye
# Rename environment-specific .env file to .env
mv /opt/micropaye/.env.${environment} /opt/micropaye/.env
chmod +x /opt/micropaye/main
echo '[END] Downloading application'

# Get database credentials from Secrets Manager
echo '[START] Getting DB credentials'
DB_SECRET=$(aws secretsmanager get-secret-value --secret-id ${db_secret_arn} --region ${region} --query SecretString --output text)
DB_HOST=$(echo $DB_SECRET | jq -r '.host')
DB_PORT=$(echo $DB_SECRET | jq -r '.port')
DB_NAME=$(echo $DB_SECRET | jq -r '.dbname')
DB_USER=$(echo $DB_SECRET | jq -r '.username')
DB_PASS=$(echo $DB_SECRET | jq -r '.password')
echo '[END] Getting DB credentials'

# Append DB credentials to .env file
echo '[START] Updating environment file'
cat >> /opt/micropaye/.env << EOF
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASS
DB_SSLMODE=require
ENVIRONMENT=${environment}
UPLOADS_BUCKET_NAME=${uploads_bucket_name}
AWS_REGION=${region}
EOF
echo '[END] Updating environment file'

# Configure systemd service for the application
echo '[START] Configuring application service'
cat > /etc/systemd/system/micropaye.service << EOF
[Unit]
Description=Micropaye Application Service
After=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/opt/micropaye
EnvironmentFile=/opt/micropaye/.env
ExecStart=/opt/micropaye/main
Restart=always
RestartSec=10
StandardOutput=append:/var/log/micropaye-${environment}.log
StandardError=append:/var/log/micropaye-${environment}_error.log

[Install]
WantedBy=multi-user.target
EOF

# Apply systemd configuration
sudo systemctl daemon-reload
sudo systemctl enable micropaye
sudo systemctl start micropaye
echo '[END] Configuring application service'

echo '[END] User data script' 