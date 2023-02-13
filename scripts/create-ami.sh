#!/usr/bin/env bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
set -e
[ "$DEBUG" == 'true' ] && set -x

AWSCLI=/usr/local/bin/aws
QEMU_IMG_BIN=tmp/work/x86_64-linux/qemu-system-native/6.2.0-r0/sysroot-destdir/build/tmp/work/x86_64-linux/qemu-system-native/6.2.0-r0/recipe-sysroot-native/usr/bin/qemu-img

ARGC=$#
if [ $ARGC -lt 2 ]; then
    echo "ERROR: Please inform import bucket name as first argument and AMI disk size in GB as second"
    exit 1
fi
IMPORT_BUCKET_NAME=$1
AMI_DISK_SIZE_GB=$2
DISTRO_ARCHITECTURE=${3:-"baremetal"} 

IMG_DIR="tmp/deploy/images/generic-arm64"
TESTDATA_JSON="${IMG_DIR}/axon-image-cloud-generic-arm64.testdata.json"

DISTRO=$(jq -r '.DISTRO' $TESTDATA_JSON)
DISTRO_CODENAME=$(jq -r '.DISTRO_CODENAME' $TESTDATA_JSON)
DISTRO_NAME=$(jq -r '.DISTRO_NAME' $TESTDATA_JSON)
DISTRO_VERSION=$(jq -r '.DISTRO_VERSION' $TESTDATA_JSON)
BUILDNAME=$(jq -r '.BUILDNAME' $TESTDATA_JSON)
BUILD_ARCH=$(jq -r '.BUILD_ARCH' $TESTDATA_JSON)
IMAGE_NAME=$(jq -r '.IMAGE_NAME' $TESTDATA_JSON)
IMAGE_ROOTFS_SIZE=$(jq -r '.IMAGE_ROOTFS_SIZE' $TESTDATA_JSON)

echo DISTRO=$DISTRO
echo DISTRO_CODENAME=$DISTRO_CODENAME
echo DISTRO_NAME=$DISTRO_NAME
echo DISTRO_VERSION=$DISTRO_VERSION
echo DISTRO_ARCHITECTURE=$DISTRO_ARCHITECTURE
echo BUILDNAME=$BUILDNAME
echo BUILD_ARCH=$BUILD_ARCH
echo IMAGE_ROOTFS_SIZE=$IMAGE_ROOTFS_SIZE
echo AMI_DISK_SIZE_GB=$AMI_DISK_SIZE_GB

echo "Converting ${IMAGE_NAME}.rootfs.wic.vhdx to raw format"
$QEMU_IMG_BIN convert -f vhdx -O raw ${IMG_DIR}/${IMAGE_NAME}.rootfs.wic.vhdx ${IMG_DIR}/${IMAGE_NAME}.rootfs.raw

echo "Pushing image ${IMAGE_NAME}.rootfs.raw to s3://${IMPORT_BUCKET_NAME}"
$AWSCLI s3 cp ${IMG_DIR}/${IMAGE_NAME}.rootfs.raw s3://${IMPORT_BUCKET_NAME}

cat <<EOF > ewaol-import.json
{
    "Description": "ewaol docker image",
    "Format": "raw",
    "UserBucket": {
        "S3Bucket": "${IMPORT_BUCKET_NAME}",
        "S3Key": "${IMAGE_NAME}.rootfs.raw"
    }
}
EOF
echo "Importing image file into snapshot "
IMPORT_TASK_ID=$($AWSCLI ec2 import-snapshot --disk-container "file://ewaol-import.json" | jq -r '.ImportTaskId')

IMPORT_STATUS=$($AWSCLI ec2 describe-import-snapshot-tasks --import-task-ids $IMPORT_TASK_ID | jq -r '.ImportSnapshotTasks[].SnapshotTaskDetail.Status')
x=0
rm ewaol-import.json
while [ "$IMPORT_STATUS" = "active" ] && [ $x -lt 120 ]
do
  IMPORT_STATUS=$($AWSCLI ec2 describe-import-snapshot-tasks --import-task-ids $IMPORT_TASK_ID | jq -r '.ImportSnapshotTasks[].SnapshotTaskDetail.Status')
  IMPORT_STATUS_MSG=$($AWSCLI ec2 describe-import-snapshot-tasks --import-task-ids $IMPORT_TASK_ID | jq -r '.ImportSnapshotTasks[].SnapshotTaskDetail.StatusMessage')
  echo "Import Status: ${IMPORT_STATUS} / ${IMPORT_STATUS_MSG}"
  x=$(( $x + 1 ))
  sleep 15
done
if [ $x -eq 120 ]; then
    echo "ERROR: Import task taking too long, exiting..."; exit 1;
elif [ "$IMPORT_STATUS" = "completed" ]; then
    echo "Import completed Successfully"
else
    echo "Import Failed, exiting"; exit 2;
fi

SNAPSHOT_ID=$($AWSCLI ec2 describe-import-snapshot-tasks --import-task-ids $IMPORT_TASK_ID | jq -r '.ImportSnapshotTasks[].SnapshotTaskDetail.SnapshotId')

$AWSCLI ec2 wait snapshot-completed --snapshot-ids $SNAPSHOT_ID

cat <<EOF > ewaol-register-ami.json
{
    "Architecture": "arm64",
    "BlockDeviceMappings": [
        {
            "DeviceName": "/dev/sda1",
            "Ebs": {
                "DeleteOnTermination": true,
                "SnapshotId": "$SNAPSHOT_ID",
                "VolumeSize": ${AMI_DISK_SIZE_GB},
                "VolumeType": "gp2"
            }
        }
    ],
    "Description": "DISTRO=$DISTRO;DISTRO_CODENAME=$DISTRO_CODENAME;DISTRO_NAME=$DISTRO_NAME;DISTRO_VERSION=$DISTRO_VERSION;DISTRO_ARCHITECTURE=$DISTRO_ARCHITECTURE;BUILDNAME=$BUILDNAME;BUILD_ARCH=$BUILD_ARCH",
    "RootDeviceName": "/dev/sda1",
    "BootMode": "uefi",
    "VirtualizationType": "hvm",
    "EnaSupport": true
}
EOF

AMI_NAME="${DISTRO}-${DISTRO_ARCHITECTURE}-${DISTRO_CODENAME}-${DISTRO_VERSION}-${BUILDNAME}-${BUILD_ARCH}"
IMAGE_ID=$($AWSCLI ec2 describe-images --filters Name=name,Values=${AMI_NAME} | jq -r '.Images[].ImageId')
if [ "$IMAGE_ID" != "" ]; then
    echo "Deregistering existing image $IMAGE_ID"
    $AWSCLI ec2 deregister-image --image-id ${IMAGE_ID} 2>&1 > /dev/null
fi
echo "Registering AMI with Snapshot $SNAPSHOT_ID"
AMI_ID=$($AWSCLI ec2 register-image --name ${AMI_NAME} --cli-input-json="file://ewaol-register-ami.json" | jq -r '.ImageId')
echo "AMI name: $AMI_NAME"
echo "AMI ID: $AMI_ID"
rm ewaol-register-ami.json

