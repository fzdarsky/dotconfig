#!/bin/sh

# Add repos
case $(uname) in
  Linux)  . /etc/os-release
          sudo subscription-manager repos --enable codeready-builder-for-rhel-${VERSION_ID%.*}-$(uname -m)-rpms
          sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID%.*}.noarch.rpm
          ;;
  Darwin) ;;
esac

# Install terminal utilities
case $(uname) in
  Linux)  sudo dnf -y copr enable atim/starship
          sudo dnf -y install \
              starship \
              tree
          ;;
  Darwin) brew install \
              bash \
              coreutils \
              starship \
              tree
          ;;
esac

# Install networking tools
case $(uname) in
  Linux)  sudo dnf -y install \
              wget \
              bind-utils \
              net-tools \
              usbutils
          ;;
  Darwin) brew install \
              wget
          ;;
esac

# Install developer tools
case $(uname) in
  Linux)  sudo dnf -y install \
              git \
              golang \
              make \
              openssl \
              openssl-devel \
              bubblewrap \
              podman-compose \
              go-rpm-macros \
              bzip2 \
              jq \
              zstd \
              shellcheck \
              protobuf-compiler
          sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
          sudo dnf install gh --repo gh-cli
          ;;
  Darwin) ;;
esac

# Install gcloud CLI
case $(uname) in
  Linux)  sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
          sudo dnf install -y libxcrypt-compat.x86_64 google-cloud-cli
          ;;
  Darwin) wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz
          tar -xf google-cloud-cli-darwin-arm.tar.gz
          rm google-cloud-cli-darwin-arm.tar.gz
          mv google-cloud-sdk .google-cloud-sdk
          ./.google-cloud-sdk/install.sh --usage-reporting false --path-update false
          ;;
esac

# Install Claude
case $(uname) in
  Linux)  case ${VERSION_ID%.*} in
          9)    sudo dnf module -y reset nodejs
                sudo dnf module -y enable nodejs:22
                sudo dnf module install -y nodejs:22/common npm
                ;;
          10)   sudo dnf install -y nodejs-npm
                ;;
          esac
          ;;
  Darwin) brew install node
          ;;
esac
mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
npm install -g @anthropic-ai/claude-code
