# devenv

**Note**: Intended for my local ENV only (Apple M2 arm64/aarch64, duh).

For x86_64, just replace aarch64/arm64/arm with x86_64 variant name (or remove it if there is no x86_64 alternative, haha)

## Overview
Working directory is `/develop`. Some volumes are attached for data persistence as below:
- `dev-container-data`: store every change in `/develop`, put your code and stuffs here
- `dev-container-go-pkg`: keep Go package cache
- `~/.ssh`: Mount SSH keys from host into `/develop/.host-ssh/` (which will have to be automatically usable in container)
- `/etc/resolv.conf`: Use the same `resolv.conf` of host for container

There are some tweak-and-tune in Dockerfile you might be interested in:
- `ln -s /develop/.ssh/config /root/.ssh/config`:
    - `/develop` is persisted so we want it to keep SSH config and locally-generated keys as well
    - Soft-link will help container recognize our SSH-related settings (**e.g**: we can update `/develop/.ssh/config` to use host's SSH keys by referring them in `/develop/.host-ssh`)
- `git config --global core.sshCommand "ssh -F /develop/.ssh/config"`:
    - Prefix any SSH-related git command to use our SSH config instead of global (actually not necessary since we have soft link, but this is just me being an extra)  

## Commands
### Start dev container (without build):
```bash
docker compose up --force-recreate --detach dev-container
```

### Build dev container:
```bash
docker compose build
```

### Start all containers:
```bash
docker compose up --force-recreate --detach
```