#!/bin/bash

# this script is intended to run all the configuration stage (after the provisioning stage)
# - configure kubectl
# - configure ansible
# - run ansible playbook

# Configure kubectl
export WORKING_DIRECTORY=$(pwd)
echo "WORKING_DIRECTORY=${WORKING_DIRECTORY}"
export ANSIBLE_ROOT="${WORKING_DIRECTORY}/ansible"
export KUBECONFIG="${WORKING_DIRECTORY}/local/kubeconfig-${ENVIRONMENT}.yml"
echo "KUBECONFIG=${KUBECONFIG}"

if [ "$RESET_SYNAPSE_DEPLOYMENT" = true ]; then
    echo "--- remove synapse deployment ---"
    "${WORKING_DIRECTORY}/scripts/remove_synapse_deployment.sh"
fi

cd $ANSIBLE_ROOT

# Configure ansible
echo "--- ansible-galaxy install collections and roles ---"
ansible-galaxy install -r "requirements.yml"

# Run ansible playbook
echo "--- playbook configuration ---"
ansible-playbook  -i inventories configuration.yml --skip-tags ${ENVIRONMENT} "$@"