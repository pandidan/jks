FROM jenkinsci/jenkins:2.65-alpine

USER root

# Plugins
RUN /usr/local/bin/install-plugins.sh \
    workflow-aggregator:2.5 \
    workflow-multibranch:2.15 \
    pipeline-stage-view:2.8 \
    pipeline-utility-steps:1.3.0 \
    pipeline-model-definition:1.1.6 \
    github-branch-source:2.0.6 \
    github-organization-folder:1.6 \
    blueocean:1.1.1 \
    ssh-agent:1.15 \
    mailer:1.20 \
    buildtriggerbadge:2.8.1 \
    hipchat:2.1.1 \
    job-dsl:1.63 \
    bitbucket:1.1.5

# Install jq, make, docker, docker-compose and doo
RUN apk --no-cache add jq make && \
    \
    curl -sL https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz | tar zx && \
        mv /docker/* /bin/ && chmod +x /bin/docker* && \
    \
    apk add --no-cache py2-pip && \
    pip install --upgrade pip && \
    pip install docker-compose==1.13.0 && \
    \
    curl -s https://raw.githubusercontent.com/thbkrkr/doo/2bb83868c04ca105912a2767465f51d1803c9fb2/doo \
        > /usr/local/bin/doo && chmod +x /usr/local/bin/doo

# Init groovy scripts
COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]