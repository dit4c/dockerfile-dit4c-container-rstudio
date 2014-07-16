#!/bin/bash

BASE_ARCH=`uname --hardware-platform`
PACKAGES=(
  # Install RStudio dependencies
  R
)
echo ${PACKAGES[@]}

# Installation....
dnf install -y ${PACKAGES[@]}
# Clean-up downloaded packages to save space
dnf clean all && yum clean all
# Install RStudio
cd /tmp && \
  curl -o rstudio-server.rpm http://download2.rstudio.org/rstudio-server-0.98.953-${BASE_ARCH}.rpm && \
  dnf install -y compat-libffi psmisc && \
  ln -s /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.6 && \
  ln -s /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.6 && \
  ln -s /usr/lib64/libgmp.so.10 /usr/lib64/libgmp.so.3 && \
  rpm -ivh --nodeps rstudio-server.rpm && \
  rm rstudio-server.rpm && \
  cd - || \
  exit 1
