# Development layout

All project repos live under `~/Development/`.

```
~/Development/
├── personal/   # personal GitHub account
└── astra/      # Astra work GitHub account
```

This repo (`~/.dots`) holds configuration only. It lives outside `~/Development/`.
It uses the personal git identity through an explicit `gitdir:~/.dots/` include in `home/git.nix`.

## Rules

| Directory | Git identity | SSH key (via `core.sshCommand`) |
|-----------|--------------|----------------------------------|
| `~/Development/personal/` | `gonzalesalec@gmail.com` | personal |
| `~/Development/astra/` | `alec@astraapplications.com` | astra |
| `~/.dots/` | `gonzalesalec@gmail.com` | personal |

Commit identity and SSH key both follow the repo location.
Remote URLs use plain `git@github.com:...`. See [git.md](git.md).

## Local containers

Podman is managed by Homebrew in `system/configuration.nix` for native macOS VM support.
OrbStack is not required. The VM is started manually (not at login):

```bash
# First setup only:
/opt/homebrew/bin/podman machine init --memory 4096
/opt/homebrew/bin/podman machine start

# When finished:
/opt/homebrew/bin/podman machine stop
```

Zsh sets `DOCKER_HOST` to the Podman machine socket automatically, preserving
any existing override. Apply with `drs` and open a new shell. This does not start
the VM automatically.

## Clone examples

```bash
git clone git@github.com:USER/repo.git ~/Development/personal/repo
git clone git@github.com:ORG/repo.git ~/Development/astra/repo
```
