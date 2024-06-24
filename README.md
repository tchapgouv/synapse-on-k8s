# Synapse on Kubernetes

![Matrix](https://img.shields.io/badge/matrix-000000?logo=Matrix&logoColor=white)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eimis-ans/eimis-synapse/lint.yml?label=lint&logo=github)
![License](https://img.shields.io/badge/license-MIT-blue.svg?logo=apache)

Runs a [Matrix](https://matrix.org/) server on a managed kubernetes cluster hosted by OVH.

## Features

- [Customized Synapse](https://github.com/eimis-ans/eimis-synapse-image) server as the Matrix messaging server along with it's database and s3 bucket
- [Customized Keycloak](https://github.com/eimis-ans/eimis-keycloak) as an alternative ID provider along with it's database
- [Element-Web](https://github.com/element-hq/element-web) as a Matrix client
- [Prometheus](https://github.com/prometheus) et [Grafana](https://github.com/grafana/grafana) for the monitoring
- The stack is also configured in a specific and configurable way cf. the ansible part.

## Prerequisites

- an account in OVH hosting provider and its credentials
(application key, application secret, consumer secret and endpoint)
- to store Terraform state files : a S3 object storage with the credentials to connect to
(access key, secret key, endpoint and region) and a bucket named terraform-states-hp-myenv for example.
- a user and credentials dedicated to openstack with the following rights : `[Network Security Operator, Volume Operator, Network Operator, Backup Operator, Compute Operator, Image Operator, Administrator, Infrastructure Supervisor]`
- to reach the future Synapse homeserver : a valid dns zone hosted by OVH
- to send some mails to users : a valid access to a SMTP service

On the linux running this code :

- the [terraform CLI](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
- the [ansible tool](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible)
- the [kubectl tool](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)
- additional needed packages : `openssl`, `yq`

## Provisioning infra

The following steps will setup various OVH resources necessary to run the Synapse homeserver.

> [!TIP]
> The Octavia load balancer is only useful if you want the cluster to be isolated from the web. If it's not necessary don't use it and remove `type: NodePort` in `ansible/roles/ingress-controller/tasks/templates/ingress-nginx-service.yml` and manually set the dns entry

- Create in the local folder a local.env.sh file copying the script/local.env.template.sh file
and fill it with all the environment variables values needed. `OS_`variables relate to the openstack part.

    Then source this file :

    ```bash
    source local/local.env.sh
    ```

- Generate the var file for provisioning stage (terraform.tfvars) based on values previously set :

    ```bash
    sh scripts/generate_provisioning_var_files.sh
    ```

- Go to the terraform folder

    ```bash
    cd terraform
    ```

- Initialize the Terraform workspace specifying the name of the S3 bucket

    ```bash
    terraform init -backend-config="bucket=terraform-states-hp-$ENVIRONMENT"
    ```

- Create the Terraform execution plan to validate that everything is ok

    ```bash
    terraform plan
    ```

- Apply the Terraform plan

    ```bash
    terraform apply
    ```

  This will lead to the creation of a kubernetes cluster with 1 control plane node and several worker nodes

## Configuration

The configuration part will be done with Ansible and is quite independent
from the provisioning part.

- Generate the files (kubeconfig-$ENVIRONMENT.yml, ansible/group_vars/all.yml) and vars needed :

  ```bash
  ./scripts/generate_configuration_var_files.sh
  ```

  For more info on kubeconfig file see <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/>
- And then  execute :

  ```bash
  ./scripts/ansible_configuration.sh
  ```

This will lead to the installation of the following components in the cluster :

- basic components :
  - an ingress controller
  - a certificate manager
- components specific to our stack :
  - a Keycloak instance along with its operator
  - the synapse stack and its customization
  - the element-web stack
  - the stunner stack used to facilitate audio/video on element
  - a prometheus/grafana stack for monitoring
  - an alpha unofficial version of a MS teams bridge

## Other credits

- The Matrix-synapse stack is based on the work done by [Alexander Olofsson](https://gitlab.com/ananace) :
<https://gitlab.com/ananace/charts/-/tree/master/charts/matrix-synapse>
- [Technology icons created by juicy_fish - Flaticon](https://www.flaticon.com/free-icons/technology)
