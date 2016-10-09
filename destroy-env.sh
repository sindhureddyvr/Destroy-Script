#!/bin/bash

echo -e "\e[31m\e[1mLab4 Destroy script"

echo -e "\e[36mCollect instance id's attached to the auto-scaling-group"
instance_id=$(aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[*].[InstanceId]')

echo -e "\e[95mSet desired capacity to 0"
aws autoscaling set-desired-capacity --auto-scaling-group-name webserverdemo --desired-capacity 0

echo -e "\e[33mWait until the instances are terminated"
aws ec2 wait instance-terminated --instance-ids $instance_id
echo -e "\e[93mWait is completed and instances in Running state are terminated"

sleep 30

echo -e "\e[31m\e[1mDeleting auto-scaling-group"
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name webserverdemo
echo -e "\e[91mAutoScaling group-name deleted"

echo -e "\e[32m\e[1mDeleting launch-configuration-group"
aws autoscaling delete-launch-configuration --launch-configuration-name webserver
echo -e "\e[92mLaunch configuration deleted"

echo -e "\e[34m\e[1mDeleting load-balancer"
aws elb delete-load-balancer --load-balancer-name itmo-544
echo -e "\e[94mLoad-balancer deleted"
