#!/usr/bin/env bash

NAME="$1"
DEST_DIR="$2"
ISDEFAULT="$3"
PROVISIONER="$4"
BINDINGMODE="$5"
VOLEXPANSION="$6"
REPOLICY="$7"
PARMS="$8"

mkdir -p "${DEST_DIR}"

cat > "${DEST_DIR}/sc.yaml" << EOL
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ${NAME}
  annotations:
    storageclass.kubernetes.io/is-default-class: '${ISDEFAULT}'
provisioner: '${PROVISIONER}'
volumeBindingMode: '${BINDINGMODE}'
allowVolumeExpansion: ${VOLEXPANSION}
reclaimPolicy: '${REPOLICY}'
EOL

PARMLENGTH=$(echo "${PARMS}" | jq '.[] | length')
echo "parmlength: ${PARMLENGTH}"
echo "parmslist: ${PARMS}"

if [[ ${PARMLENGTH} != 0 ]]; then

cat >> ${DEST_DIR}/sc.yaml << EOL
parameters: 
$(echo "${PARMS}" | jq -r '.[] |  "\(.key): \(.value)"' | awk '{printf "  %s\n", $0}')
EOL
fi 

