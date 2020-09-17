# Automate setup of AWS EC2 with Application Load Balancer and Auto Scaling enabled
------------------------------------
1. Prerequisites
------------------------------------

1.1. Terraform CLI
Ensure terraform CLI is available. If not, then do install it first.

1.2. Individual AWS IAM user
Prepare a new individual IAM user with programmatic access key enabled and have access to EC2 management. We will use the access_key and secret_key on this tutorial. If you haven't created the IAM user, then follow a guide on Create Individual IAM User.

1.3. ssh-keygen and ssh commands
Ensure both ssh-keygen and ssh command are available.

------------------------------------
2. Preparation
------------------------------------

Create a new folder contains respective .tf files. We will use the files as the infrastructure code. Every resource setup will be written in HCL language inside the file, including:

Uploading key pair (for ssh access to the instance).
Subnetting on two different availability zones (within the same region).
Defining Application Load Balancer, it's listener, security group, and target group.
Defining Auto-scaling and it's launch config.

mkdir Terraform-AWS-automate
cd Terraform-AWS-automate
create respective files as shown below:

cdn.tf
ec2.tf
efs.tf
key.tf
lb.tf
output.tf
provider-variable.tf
s3.tf
securitygroup.tf

Next, create a public-key cryptography using ssh-keygen command below. This will generate the id_rsa.pub public key and id_rsa private key. Later we will upload the public key into AWS and use the private key to perform ssh access into the newly created EC2 instance.

cd Terraform-AWS-automate
ssh-keygen -t rsa -f ./id_rsa

------------------------------------
3. Infrastructure Code
------------------------------------

Write respective code in files created as per below steps:

3.1. Define AWS provider
Define the provider block with AWS as chosen cloud provider. Also define these properties: region, access_key, and secret_key; with values derived from the created IAM user.

3.2. Generate new key pair then upload to AWS

3.3. Book a VPC, and enable internet gateway on it

3.4. Allocate two different subnets on two different availability zones (within the same region)
Application Load Balancer or ALB requires two subnets setup on two availability zones (within the same region).

3.5. Define ALB resource block, listener, security group, and target group
The ALB will be created with two subnets attached

The security group for our load balancer has only two rules.
Allow only incoming TCP/HTTP request on port 80.
Allow every kind of outgoing request.
Prepare the ALB listener.

3.6. Define launch config (and it's required dependencies) for auto-scaling
The instance creation and app deployment will be automated using AWS auto-scaling feature.
The launched instance will have a public IP attached, this is better to be set to false, but in here we might need it for testing purposes.
The previously allocated key pair will also be used on the instance, to make it accessible through SSH access. This part is also for testing purposes.
Other than that, there is one point left that is very important, the user_data. The user data is a block of bash script that will be executed during instance bootstrap. We will use this to automate the deployment of our application. The whole script is stored in a file named deployment.sh, we will prepare it later.
the autoscale launch config is ready, now we shall attach it into our ALB.

3.7. Print the ALB public DNS

------------------------------------
4. App Deployment Script
------------------------------------
Deploying app means that the app is ready (has been built into binary), so what we need is simply just run the binary.

------------------------------------
5. Run Terraform
------------------------------------

5.1. Terraform initialization
First, run the terraform init command. This command will do some setup/initialization, certain dependencies (like AWS provider that we used) will be downloaded.

terraform init

5.2. Terraform plan
Next, run terraform plan, to see the plan of our infrastructure. This step is optional, however, might be useful for us to see the outcome from the infra file.

5.3. Terraform apply
Last, run the terraform apply command to execute the infrastructure plan.

terraform apply -auto-approve

The -auto-approve flag is optional, it will skip the confirmation prompt during execution.
After the process is done, public DNS shall appear. Next, we shall test the instance.

------------------------------------
6. Test Instance
------------------------------------

Use the curl command to make an HTTP request to the ALB public DNS instance.

curl -X GET <ALB>.<AWS-Region>.elb.amazonaws.com
