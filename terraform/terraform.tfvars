aws-region              = "YOUR_REGION" #AWS region
aws-environment         = "YOUR_ENVIRONMENT_NAME" #For example 'development', 'staging', 'prod'
project-name            = "YOUR_PROJECT_NAME"
subnet-count            = "2" #Count for availability zones in your region. 
authorized-ip           = "YOUR_IP_ADDRESS/32" #Generally your public IP with netmask /32.
key-pair-name           = "YOUR_KEY" #Used for connect with ec2 instances
instance-type           = "t3.medium" #instance type for eks workers