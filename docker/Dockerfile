FROM debian:9

WORKDIR /root

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

## Install packages
RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian \
      $(lsb_release -cs) \
      stable" && \
    apt-get update && \
    apt-get install --no-install-recommends --yes docker-ce awscli git openssh-client && \
    apt-get -y autoremove ; \
    apt-get clean && apt-get autoclean ; \
    rm -rf /tmp/* /var/tmp/* ; \
    rm -rf /var/lib/apt/lists/* ; \
    rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin


COPY start.sh start.sh
CMD ["/root/start.sh"]
