#!/bin/bash

# this script is intended to generate the files and vars needed to let the configuration step work with Ansible :
# - kubeconfig file from the output of terraform
# - connexion to database from the output of terraform
# - group_vars/all.yml needed by Ansible

LOCAL=../local
(
    cd terraform
    echo "Getting terraform outputs"
    echo "kubeconfig"
    terraform output --raw kubeconfig >$LOCAL/kubeconfig.yml
    chmod 600 $LOCAL/kubeconfig.yml
    echo "done."
    echo "ssh private key"
    terraform output --raw vm_admin_private_key > $LOCAL/ssh_private_key.pem
    chmod 600 $LOCAL/ssh_private_key.pem
    echo "done."
    echo "Other outputs"
    terraform output -json >terraform_output.json
    echo "done."


    export SYNAPSE_DATABASE_URL=$(jq -r ". | .\"synapse_databse_uri\".value" terraform_output.json)
    export SYNAPSE_DB_PASSWORD=$(jq -r ". | .\"synapse_db_password\".value" terraform_output.json)
    export SYNAPSE_DB_HOST=$(jq -r ". | .\"synapse_db_host\".value" terraform_output.json)
    export SYNAPSE_DB_PORT=$(jq -r ". | .\"synapse_db_port\".value" terraform_output.json)
    export AVNADMIN_DB_PASSWORD=$(jq -r ". | .\"avnadmin_db_password\".value" terraform_output.json)
    export S3_MEDIA_BUCKET_NAME=$(jq -r ". | .\"s3_media_repo_bucket_name\".value" terraform_output.json)
    export S3_MEDIA_REPO_URL=$(jq -r ". | .\"s3_media_repo_url\".value" terraform_output.json)
    export S3_MEDIA_REPO_ACCESS_KEY=$(jq -r ". | .\"s3_media_repo_access_key\".value" terraform_output.json)
    export S3_MEDIA_REPO_SECRET_KEY=$(jq -r ". | .\"s3_media_repo_secret_key\".value" terraform_output.json)
    export S3_REGION=$(echo $GLOBALE_REGION  | tr '[:upper:]' '[:lower:]')
    export KEYCLOAK_DB_PASSWORD=$(jq -r ". | .\"keycloak_db_password\".value" terraform_output.json)
    export KEYCLOAK_DB_AVNADMIN_PASSWORD=$(jq -r ". | .\"avnadmin_keycloak_db_password\".value" terraform_output.json)
    export KEYCLOAK_DB_HOST=$(jq -r ". | .\"keycloak_db_host\".value" terraform_output.json)
    export KEYCLOAK_DB_PORT=$(jq -r ". | .\"keycloak_db_port\".value" terraform_output.json)
    export BASE_URL=$(jq -r ". | .\"base_url\".value" terraform_output.json)
    export REDIS_PASSWORD=$(openssl rand -base64 14)

    envsubst <"../ansible/group_vars/env_vars.tmpl" > ../ansible/group_vars/all.yml
)
