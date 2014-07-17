# DOCKER-VERSION 1.0
FROM dit4c/project-base
MAINTAINER t.dettrick@uq.edu.au

# Install R
RUN yum install -y R

# Install RStudio
RUN cd /tmp && \
  export BASE_ARCH=`uname --hardware-platform` && \
  curl -o rstudio-server.rpm http://download2.rstudio.org/rstudio-server-0.98.953-${BASE_ARCH}.rpm && \
  yum install -y compat-libffi psmisc && \
  ln -s /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.6 && \
  ln -s /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.6 && \
  ln -s /usr/lib64/libgmp.so.10 /usr/lib64/libgmp.so.3 && \
  rpm -ivh --nodeps rstudio-server.rpm && \
  rm rstudio-server.rpm && \
  cd -

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var
# Chowned to root, so reverse that change
RUN chown -R researcher /var/log/easydav /var/log/supervisor

# Check nginx config is OK
RUN nginx -t