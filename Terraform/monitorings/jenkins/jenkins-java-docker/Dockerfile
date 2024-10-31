FROM jenkins/inbound-agent:alpine-jdk21

USER root

RUN apk --no-cache add bash curl wget jq yq git tar unzip bash-completion ca-certificates docker docker-cli && \
    curl -LO "https://services.gradle.org/distributions/gradle-8.10.2-bin.zip" && \
    unzip gradle-8.10.2-bin.zip -d /opt/gradle && \
    rm gradle-8.10.2-bin.zip


ENV GRADLE_HOME="/opt/gradle/gradle-8.10.2" 
ENV PATH="$PATH:${GRADLE_HOME}/bin"

USER jenkins