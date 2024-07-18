#!/bin/bash

kubectl delete deployment matrix-synapse matrix-synapse-redis-master matrix-synapse-wellknown-lighttpd

SECRETS=$(kubectl get secrets | grep matrix-synapse | awk '{print $1}')
kubectl delete secret $SECRETS

CONFIGMAPS=$(kubectl get cm | grep matrix-synapse | awk '{print $1}')
kubectl delete cm $CONFIGMAPS