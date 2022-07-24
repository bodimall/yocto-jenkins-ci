FROM jenkins/ssh-agent:bullseye-jdk11@sha256:ac10b489b8baa434386f97f9d441b4be9bfd42f8a0f85e403af19def2f18eb9b

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    software-properties-common

#
# Docker install
#
RUN apt-get update && apt-get install --no-install-recommends -y \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
RUN apt-get update && apt-get install --no-install-recommends -y \
       docker-ce docker-ce-cli containerd.io

RUN usermod -a -G docker jenkins

#
# supervisord
#
RUN apt-get install --no-install-recommends -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#
# Entrypoint
#
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

# prepare director for artifact publishing
RUN mkdir -p /var/www/jenkins && chown jenkins:jenkins -R /var/www/jenkins

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
