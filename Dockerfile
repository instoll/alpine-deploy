FROM alpine:3.3

# Install OS dependencies.
RUN echo "System dependencies" && \
    apk add --update curl make git bash vim ca-certificates && \
    echo "Ruby dependencies" && \
    apk add ruby ruby-io-console ruby-bundler && \
    gem install aws-sdk && \
    echo "Python dependencies" && \
    apk add python py-pip openssl ca-certificates && \
    apk add --virtual build-dependencies \
      python-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi && \
    echo "Ansible dependencies" && \
    pip install 'ansible==2.3.0.0' \
                'boto==2.46.1' \
                'boto3==1.4.1' \
                'docker-compose==1.8.1' \
                'docker-py==1.10.6' \
                'MarkupSafe==0.23' && \
    echo "Terraform dependencies" && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/0.9.5/terraform_0.9.5_linux_amd64.zip && \
    unzip terraform_0.9.5_linux_amd64.zip && \
    mv terraform /usr/bin && \
    rm -f terraform_0.9.5_linux_amd64.zip && \
    echo "Cleanup" && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*
