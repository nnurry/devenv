FROM almalinux:10

RUN dnf install -y epel-release \
    && dnf clean all \
    && dnf makecache \
    && dnf update -y

RUN dnf install -y \
    git \
    zip \
    unzip \
    bash-completion \
    golang \
    nano \
    vim \
    bat \
    tree

RUN bash -c "curl -fsSL https://claude.ai/install.sh | bash"

ARG DEVCONTAINER_BASE_DIR

RUN git config --global core.sshCommand "ssh -F ${DEVCONTAINER_BASE_DIR}/.ssh/config"
RUN git config --global gpg.format ssh
RUN mkdir ${HOME}/.ssh

RUN ln -s ${DEVCONTAINER_BASE_DIR}/.ssh/config ${HOME}/.ssh/config

RUN bash -c "echo 'source /etc/profile.d/bash_completion.sh' >> ${HOME}/.bashrc"
