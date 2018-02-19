FROM alpine:3.7

ENV TF_VERSION 0.11.3
ENV TF_FILE    terraform_${TF_VERSION}_linux_amd64.zip

# Install OS dependencies.
RUN echo "System dependencies" && \
    apk add --update curl make git bash vim ca-certificates && \
    echo "Docker in Docker dependencies" && \
    apk add docker && \
    echo "Ruby dependencies" && \
    apk add ruby ruby-io-console ruby-bundler && \
    echo "Ruby Gem dependencies" && \
    echo 'gem: --no-document' >> ~/.gemrc && \
    gem install aws-sdk && \
    echo "Python dependencies" && \
    apk add python py-pip openssl ca-certificates && \
    apk add --virtual build-dependencies \
      python-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi && \
    echo "Ansible dependencies" && \
    pip install 'ansible==2.4.2.0' \
                'awscli==1.14.19' \
                'boto==2.48.0' \
                'boto3==1.5.9' \
                'docker-compose==1.18.0' \
                'docker-py==1.10.6' \
                'MarkupSafe==0.23' && \
    echo "Terraform dependencies" && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_FILE} && \
    unzip ${TF_FILE} && \
    mv terraform /usr/bin && \
    rm -f ${TF_FILE} && \
    echo "Cleanup" && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*
