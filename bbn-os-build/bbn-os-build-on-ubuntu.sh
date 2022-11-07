#!/bin/bash -e

# For Ubuntu 16.04.7

export DOCKER_IMAGE=arm32v7/debian:buster
export CONTAINER_DISTRO=debian:buster
export PKG_RELEASE=raspbian
export PKG_DISTRO=buster
export PKG_ARCH=armhf
export EMU=on

WORK_DIR=$(pwd)/ci-source
echo "Present working directory is: " $pwd
apt-get install curl git docker.io zerofree kpartx

rm -rf $WORK_DIR
mkdir $WORK_DIR && cd $WORK_DIR
echo "Present working directory is: " $WORK_DIR
git clone --branch buster https://github.com/bareboat-necessities/lysmarine_gen .
#git clone --branch incremental https://github.com/bareboat-necessities/lysmarine_gen .

mv *install-scripts* cross-build-release/
echo "Contents of cross-build-release/ is: "
ls -al
chmod a+x .circleci/*.sh

.circleci/build-ci.sh 2>&1 | tee build.log

IMG=$(ls cross-build-release/release/*/*.img)
xz -z -c -v -6 --threads=8 $IMG > $IMG.xz
