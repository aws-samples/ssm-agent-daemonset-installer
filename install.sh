#!/bin/sh

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
STATUS=$(sudo systemctl status amazon-ssm-agent)

if echo $STATUS | grep -q "running"; then
    echo "Install succeeded"
else
    echo "Install failed" >&2 
fi