# Kops Kubernetes Installer
#
# To build:
# docker build -t kops .
#
# To run:
# docker run -it --rm \
# -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
# -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
# kops COMMAND
FROM debian:stable-slim

RUN \
  apt update && \
  apt upgrade -y && \
  apt install -y curl python-pip vim

RUN \
  pip install awscli && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin/. && \
  curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
  chmod +x kops-linux-amd64 && \
  mv kops-linux-amd64 /usr/local/bin/kops && \
  curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz && \
  tar -xvzf helm-v2.14.0-linux-amd64.tar.gz && \
  chmod +x linux-amd64/tiller && \
  chmod +x linux-amd64/helm && \
  rm -rf helm-v2.14.0-linux-amd64.tar.gz linux-amd64

ENTRYPOINT ["/usr/local/bin/kops"]
