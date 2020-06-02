# Terraform GCP

## Overview

Manage Google Cloud Project Resources

## Dependencies

* Terraform (See required_version in main.tf)
* Google Provider with Google Cloud Storage Backend

Google Provider requires valid credentials which can be provided in the following forms:
* User OAuth Access Token: `GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)`
* Service Account Credentials json: `GOOGLE_CREDENTIALS=service_account.json`

Information about the GCS Backend:
* Required to persist the terraform statefile [Terraform State](https://www.terraform.io/docs/state/index.html)
* Object versioning is enabled [Object Versioning](https://cloud.google.com/storage/docs/using-object-versioning)
