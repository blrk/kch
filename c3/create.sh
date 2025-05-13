#!/bin/bash

# Array of namespaces
namespaces=("mtvlabk8su1" "mtvlabk8su2" "mtvlabk8su3")

 # Pathto your Kubernetes manifest files
postgres_deployment_file="postgres-deploy.yml" # Make sure these paths are correct
pvc_file="pvc.yml"
secret_file="secret.yml"

set -e # Exit immediately if a command exits with a non-zero status

# Deploy PostgreSQL to the given namespace
deploy_postgres() {
  local namespace="$1"
  echo "Deploying PostgreSQL to namespace '$namespace'..."
  kubectl apply -f "$pvc_file" -n "$namespace"
  if [ $? -ne 0 ]; then
    echo "Failed to apply PVC to namespace ${namespace}"
    exit 1
  fi
  kubectl apply -f "$secret_file" -n "$namespace"
    if [ $? -ne 0 ]; then
    echo "Failed to apply Secret  to namespace ${namespace}"
    exit 1
  fi
  kubectl apply -f "$postgres_deployment_file" -n "$namespace"
  if [ $? -ne 0 ]; then
    echo "Failed to apply PostgreSQL Deployment to namespace ${namespace}"
    exit 1
  fi
  echo "PostgreSQL deployment started in namespace '$namespace'."
}

# Main deployment sequence
for namespace in "${namespaces[@]}"; do
  deploy_postgres "$namespace"
done

echo "PostgreSQL deployment process completed in all specified namespaces."

