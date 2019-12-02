FROM alpine:3.10

ENV TF_VERSION 0.12.16
ENV TF_FILE    terraform_${TF_VERSION}_linux_amd64.zip

# Install OS dependencies.
RUN echo "System dependencies" && \
      apk add --update \
        bash \
        curl \
        git \
        make \
        ca-certificates && \
    echo "Docker in Docker dependencies" && \
      apk add \
        docker \
        git && \
    echo "Ruby dependencies" && \
      apk add \
        ruby \
        ruby-bundler \
        ruby-io-console \
        ruby-json && \
    echo "Ruby Gem dependencies" && \
      echo 'gem: --no-document' >> ~/.gemrc && \
      gem install aws-sdk && \
    echo "Python3 dependencies" && \
      apk add \
        python3 \
        openssl && \
      apk add --virtual build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        python3-dev && \
    echo "Symlink Python3 dependencies" && \
      ln -s /usr/bin/python3 /usr/bin/python && \
      ln -s /usr/bin/pip3 /usr/bin/pip && \
    echo "Ansible dependencies" && \
      pip --no-cache-dir install --upgrade \
        cffi \
        pip \
        pyyaml && \
      pip --no-cache-dir install \
        ansible==2.9.1 \
        awscli==1.16.293 \
        boto==2.49.0 \
        boto3==1.10.29 \
        docker-compose==1.25.0 \
        docker==4.1.0 \
        MarkupSafe==1.1.1 && \
    echo "Terraform dependencies" && \
      cd /tmp && \
      wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_FILE} && \
      unzip ${TF_FILE} && \
      mv terraform /usr/bin && \
      rm -f ${TF_FILE} && \
    echo "Cleanup" && \
      apk del build-dependencies && \
      rm -rf ~/.cache/pip && \
      rm -rf /var/cache/apk/*
