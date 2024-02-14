#!/usr/bin/env bash

# Enable the required APIs
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable workstations.googleapis.com


# Define the IAM roles for the Cloudbuild service account
ROLES=(
  "roles/container.admin"
  "roles/cloudsql.admin"
  "roles/storage.admin"
  "roles/artifactregistry.admin"
  "roles/workstations.admin"
  "roles/source.admin"
  "roles/resourcemanager.projectIamAdmin"
  "roles/iam.serviceAccountAdmin"
  "roles/compute.admin"
  "roles/iam.serviceAccountUser"
)

PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')

# Loop through each role and assign it to the Cloudbuild service account
for ROLE in "${ROLES[@]}"; do \
    gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com --role="${ROLE}"
done
