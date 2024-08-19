# VPCPeerLab

This is a simple repo/lab to deploy 2 EC2 instances that can talk to each other from different subnets, via terraform.

This may mostly be useless in the real world - but allows the use of enivronment variables/tfvars and IaC management in a reasonably simple set up. As well as some understanding of the networking principles required.

We will: 

- Write the main.tf file to deploy:
    - 2 EC2 Instances (allowing SSH)
    - 2 VPC's
    - 2 Security groups (attached to the VPC's)

- Write the provider.tf and version.tf

- Write the outputs.tf

- Write the tfvars files which will allow us to deploy/manage the working model all within one deployment
 
If we are great success, we should be able to SSH into either of the EC2 instances, and ping the other, using the assinged IP address within the subnet range.

> If you are feeling fancy, dont look at the IP of the other EC2 instance, find it by scanning the network with nmap




----------------------------------------------------------------
# “The secret to creativity is knowing how to hide your sources.” — Unknown



