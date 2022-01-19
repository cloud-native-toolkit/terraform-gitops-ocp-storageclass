#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)

BRANCH="main"
SERVER_NAME="default"
TYPE="base"
LAYER="1-infrastructure"

COMPONENT_NAME="ocpstorageclass"
NAMESPACE="default"

STORNAME=$(cat git_sc_name)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/sc.yaml" ]]; then
  echo "Application values not found - payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/sc.yaml"
  exit 1
fi

echo "Printing payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/sc.yaml"
cat "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/sc.yaml"

count=0
until kubectl get StorageClass ${STORNAME} || [[ $count -eq 15 ]]; do
  echo "Waiting for StorageClass ${STORNAME} to deploy"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 15 ]]; then
  echo "Timed out waiting for StorageClass ${STORNAME} to deploy"
  exit 1
fi

kubectl get StorageClass ${STORNAME} || exit 1

cd ..
rm -rf .testrepo


