FROM python:3-slim

# Install python dependencies.
RUN pip3 install --no-cache-dir --upgrade \
         python-crontab==2.3              \
         requests==2.19
         
# Install cron to automate updates.
# Install nginx. |daemon off| prevents nginx from daemonizing.
# Install minecraft-overviewer
EXPOSE 80
RUN apt-get update                                                             &&\
    apt-get install -y wget gnupg                                              &&\
    echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list        &&\
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - &&\
    apt-get update                                                             &&\
    apt-get install -y nginx cron minecraft-overviewer                         &&\
    rm /etc/nginx/sites-enabled/default                                        &&\
    echo 'daemon off;' >> /etc/nginx/nginx.conf                                &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy source files and create working directories.
COPY src /src
RUN mv /src/server.nginx /etc/nginx/sites-enabled && mkdir -p /public /build && touch /config.json

CMD ["/src/entry.sh"]
