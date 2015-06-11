# DOCKER-VERSION 1.0
FROM quay.io/dit4c/dit4c-container-base:fakeroot
MAINTAINER t.dettrick@uq.edu.au

# Install R
#  - R
#  - libcurl-devel (necessary for RCurl package, a dependency of devtools)
RUN rpm --rebuilddb && fsudo yum install -y R libcurl-devel

# Install RStudio
RUN cd /tmp && \
  export BASE_ARCH=`uname --hardware-platform` && \
  fsudo yum install -y compat-libffi psmisc && \
  chmod u+w /usr/lib64/ && \
  ln -s /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.6 && \
  ln -s /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.6 && \
  ln -s /usr/lib64/libgmp.so.10 /usr/lib64/libgmp.so.3 && \
  fsudo rpm -ivh --nodeps http://download2.rstudio.org/rstudio-server-0.98.953-${BASE_ARCH}.rpm && \
  cd -

# Install R packages used in intermediate bootcamp
RUN Rscript -e \
  " options(repos=structure(c(CRAN='http://cran.ms.unimelb.edu.au'))); \
    install.packages('ggplot2', dependencies = TRUE); \
    install.packages(c( \
      'knitr', \
      'testthat', \
      'assertthat', \
      'stringr', \
      'pander', \
      'plyr', \
      'ggthemes', \
      'reshape2', \
      'gridExtra', \
      'RCurl', \
      'devtools', \
      'data.table'))"

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var

# Because COPY doesn't respect USER...
USER root
RUN chown -R researcher:researcher /etc /var
USER researcher

# Check nginx config is OK
RUN nginx -t
