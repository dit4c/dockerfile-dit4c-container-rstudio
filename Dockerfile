# DOCKER-VERSION 1.0
FROM dit4c/project-base
MAINTAINER t.dettrick@uq.edu.au

# Run install script inside the container
COPY install.sh /tmp/install.sh
RUN bash /tmp/install.sh

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY opt /opt
COPY var /var
# Chowned to root, so reverse that change
RUN chown -R researcher /var/log/easydav /var/log/supervisor
RUN chown -R nginx /var/lib/nginx
