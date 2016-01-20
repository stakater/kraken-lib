#!/bin/bash -
#title           :terraform-down.sh
#description     :run terraform with parameters. This is intended to be executed inside a docker container.
#author          :Samsung SDSRA
#==============================================================================

set -o errexit
set -o nounset
set -o pipefail

source "/opt/kraken/docker-utils.sh"

if [ -z ${KRAKEN_CLUSTER_TYPE+x} ]; then
  error "--clustertype not specified."
  exit 1
fi

if [ -z ${KRAKEN_CLUSTER_NAME+x} ]; then
  error "--clustername not specified."
  exit 1
fi

until terraform destroy \
  -force \
  -input=false \
  -var-file=/opt/kraken/terraform/${KRAKEN_CLUSTER_TYPE}/${KRAKEN_CLUSTER_NAME}/terraform.tfvars \
  -state=/kraken_data/${KRAKEN_CLUSTER_NAME}/terraform.tfstate \
  -var 'cluster_name=${KRAKEN_CLUSTER_NAME}' \
  /opt/kraken/terraform/${KRAKEN_CLUSTER_TYPE}; \
  do echo 'Retrying...'; sleep 5; done;

rm -rf /kraken_data/${KRAKEN_CLUSTER_NAME}