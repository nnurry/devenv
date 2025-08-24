FROM ubuntu:noble

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    software-properties-common \
    git \
    unzip \
    curl \
    groff && \
    add-apt-repository ppa:ondrej/php -y && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    mysql-client-8.0 \
    postgresql-client-16 \
    bash-completion \
    openjdk-17-jdk \
    locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    npm install --global yarn

SHELL ["/bin/bash", "-i", "-c"]

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -rf aws

RUN curl -LO https://golang.org/dl/go1.24.2.linux-arm64.tar.gz && \
    tar -C /root -xzf go1.24.2.linux-arm64.tar.gz && \
    rm go1.24.2.linux-arm64.tar.gz && \
    curl -OL https://github.com/golang-migrate/migrate/releases/download/v4.18.3/migrate.linux-arm64.deb && \
    dpkg -i migrate.linux-arm64.deb && \
    rm migrate.linux-arm64.deb

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    php8.4-cli \
    php8.4-dev \
    php8.4-curl \
    php8.4-soap \
    php8.4-zip \
    php8.4-gmp \
    php8.4-gd \
    php8.4-mysql \
    php8.4-pgsql \
    php8.4-opentelemetry \
    php8.4-bcmath \
    php8.4-intl \
    php8.4-mbstring \
    php8.4-gnupg \
    php8.4-redis \
    php8.4-simplexml && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN ["/root/go/bin/go", "install", "golang.org/x/tools/gopls@latest"]
RUN ["/root/go/bin/go", "install", "honnef.co/go/tools/cmd/staticcheck@latest"]
RUN ["/root/go/bin/go", "install", "golang.org/x/lint/golint@latest"]

RUN apt-get update -y && \
    apt-get install -y \
    python3-dev \
    python3.12-venv \
    libvirt-dev \
    btop \
    htop \
    nano \
    vim \
    bat \
    iputils-ping \
    qemu-system-arm \
    protobuf-compiler \
    protoc-gen-go \
    protoc-gen-go-grpc \
    bridge-utils \
    dmidecode \
    dnsmasq \
    ebtables \
    iproute2 \
    iptables \
    libvirt-clients \
    libvirt-daemon-system \
    ovmf \
    qemu-kvm \
    tini \
    tree

RUN git config --global core.sshCommand "ssh -F /develop/.ssh/config"
RUN git config --global gpg.format ssh
RUN ln -s /develop/.ssh/config /root/.ssh/config

ENV GNUPGHOME=/develop/.gnupg

RUN ["/bin/bash", "-c", "echo 'source /etc/profile.d/bash_completion.sh' >> /root/.bashrc"]
RUN ["/bin/bash", "-c", "echo 'export PATH=$PATH:/root/go/bin' >> /root/.bashrc"]
