FROM alpine:3.10

ENV TF_VERSION 0.12.24
ENV TF_FILE    terraform_${TF_VERSION}_linux_amd64.zip

ENV VAULT_VERSION 1.4.0
ENV VAULT_FILE    vault_${VAULT_VERSION}_linux_amd64.zip

# Install OS dependencies.
RUN echo "System dependencies" && \
      apk add --update \
        bash \
        curl \
        git \
        gnupg \
        jq \
        make \
        openssh \
        ca-certificates && \
    echo "Docker in Docker dependencies" && \
      apk add \
        docker \
        git && \
    echo "Python3 dependencies" && \
      apk add \
        python3 \
        openssl && \
      apk add --virtual build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        python3-dev && \
    echo "Install yq" && \
      wget https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 -O /usr/bin/yq && \
      chmod 0755 /usr/bin/yq && \
    echo "Symlink Python3 dependencies" && \
      ln -s /usr/bin/python3 /usr/bin/python && \
      ln -s /usr/bin/pip3 /usr/bin/pip && \
    echo "Ansible dependencies" && \
      pip --no-cache-dir install --upgrade \
        cffi \
        pip \
        pyyaml && \
      pip --no-cache-dir install \
        ansible==2.9.7 \
        awscli==1.18.41 \
        boto==2.49.0 \
        boto3==1.12.41 \
        docker-compose==1.25.5 \
        docker==4.2.0 && \
    echo "Terraform dependencies" && \
      cd /tmp && \
      wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_FILE} && \
      unzip ${TF_FILE} && \
      mv terraform /usr/bin && \
      rm -f ${TF_FILE} && \
    echo "Vault dependencies" && \
      wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_FILE} && \
      unzip ${VAULT_FILE} && \
      mv vault /usr/bin && \
      rm -f ${VAULT_FILE} && \
    echo "Cleanup" && \
      apk del build-dependencies && \
      rm -rf ~/.cache/pip && \
      rm -rf /var/cache/apk/*
