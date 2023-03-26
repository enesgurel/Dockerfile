FROM jenkins/jenkins:lts

ARG HOST_DOCKER_GROUP_ID

USER root

# Create 'docker' group with provided group ID 
# and add 'jenkins' user to it
RUN groupadd docker -g ${HOST_DOCKER_GROUP_ID} && \
    usermod -a -G docker jenkins

# Install 'docker-ce' and it's dependencies 
# https://docs.docker.com/engine/installation/linux/docker-ce/debian/
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        docker-ce && \
    apt-get clean