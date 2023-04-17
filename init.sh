#/bin/bash
set -e

PROJECT_ID=$(grep project_id terraform/terraform.tfvars | cut -d "\"" -f 2)

read -e -p "PROJECT: $PROJECT_ID. Press any key to continue."

gcloud storage buckets create gs://${PROJECT_ID}-tools --location=EU
gcloud compute firewall-rules delete default-allow-icmp default-allow-internal default-allow-rdp default-allow-ssh
gcloud compute networks delete default

cd terraform
terraform init -backend-config="bucket=$(grep project_id terraform.tfvars | cut -d "\"" -f 2)-tools"
