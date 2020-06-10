# Terraform-Provisionning

Terraform is a great tool for provisionning infrastructure. With the need of Terraform, you can add resources as you want and make your infrastructure the larger that you want.

# Steps

## Step1: Download Terraform on your laptop

You can download Terraform from the official site: ***https://www.terraform.io/downloads.html***

## Step2: Setup the Terraform as a environement variable


>unzip terraformfile.zip
>echo "PATH='$PATH:~/downloads/'" >> .bash_profile
>source .bash_profile
>terraform

## Step3: create your service account

In GCP, create your service account with owner permission

## Step4: Create a Service Account Key within the Instance 

>gcloud auth login
>gcloud iam service-accounts keys create credentials.json --iam-account <SERVICE_ACCOUNT>

## Step5: Create the configuration files

You create your configuration files and change your name project and the path to your file ***credentials.json***

## Step6: run your Terraform commands

>terraform init
>terraform validate
>terraform plan
>terraform apply
