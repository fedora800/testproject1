#!/bin/bash
# check for a particular file across multiple hosts

REMOTE_HOSTS=(
    "oci-cpane1"
    "oci-worker1"
)

TARGET_DIR="/home/${USER}/k8s_manifests"
FILE_PATTERN="*deploy*yaml"
USER=$LOGNAME

for RHOST in "${REMOTE_HOSTS[@]}"; do
  echo; echo "==${RHOST}=="
  ssh -T -o ConnectTimeout=5 ${USER}@${RHOST} <<EOF
    FILE=\$(find ${TARGET_DIR} -name ${FILE_PATTERN} -type f)
    ls -l \$FILE
    wc -l \$FILE
    sha256sum \$FILE
EOF

done

