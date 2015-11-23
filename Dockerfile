# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base:withroot
MAINTAINER t.dettrick@uq.edu.au

# Install R
#  - R
#  - libcurl-devel (necessary for RCurl package, a dependency of devtools)
RUN rpm --rebuilddb && yum install -y R libcurl-devel openssl-devel libxml2-devel

# Install RStudio
RUN cd /tmp && \
  export BASE_ARCH=`uname --hardware-platform` && \
  rpm --rebuilddb && \
  yum install -y psmisc  https://download2.rstudio.org/rstudio-server-rhel-0.99.489-${BASE_ARCH}.rpm && \
  cd -

# Install R packages used in intermediate bootcamp
RUN Rscript -e \
  " options(repos=structure(c(CRAN='http://cran.csiro.au'))); \
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

# Check nginx config is OK
RUN nginx -t
