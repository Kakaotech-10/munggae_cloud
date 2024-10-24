FROM jenkins/inbound-agent:3261.v9c670a_4748a_9-1

USER root
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g npm@latest && \
    apt-get install -y awscli && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER jenkins
