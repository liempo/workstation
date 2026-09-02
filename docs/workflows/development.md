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

## Clone examples

```bash
git clone git@github.com:USER/repo.git ~/Development/personal/repo
git clone git@github.com:ORG/repo.git ~/Development/astra/repo
```
