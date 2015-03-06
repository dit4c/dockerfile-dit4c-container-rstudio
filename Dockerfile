# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base
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
  
# Install libcurl-devel (necessary for RCurl package, a dependency of devtools)
RUN yum install -y libcurl-devel

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
# Chowned to root, so reverse that change
RUN chown -R researcher /var/log/easydav /var/log/supervisor

# Check nginx config is OK
RUN nginx -t
