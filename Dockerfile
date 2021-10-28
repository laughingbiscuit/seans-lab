FROM alpine:3.14

RUN apk update
RUN apk add curl docker jq tmux git lastpass-cli
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
RUN wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sh


