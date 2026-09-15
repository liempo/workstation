# Syncthing

`home/liempo.nix` enables Syncthing through Home Manager's macOS launchd user
agent. Do not also run a Homebrew or standalone-app Syncthing service.
The dashboard is loopback-only at <http://127.0.0.1:8384>.
Device and folder settings are managed in the GUI and survive rebuilds.

## Apply on workstation

From `~/.dots`, follow [Rebuild](rebuild.md): validate the pure configuration,
then run `drs` when ready. No activation is implied by pulling the branch.
The user agent runs in your login session; the Mac must be awake to sync.

```sh
nix build .#darwinConfigurations.workstation.config.system.build.toplevel --no-link
# After reviewing pending changes:
drs
launchctl list | grep -i syncthing
```

Open the dashboard and set a GUI username/password. If macOS blocks incoming
Syncthing connections, allow Syncthing specifically rather than disabling the
firewall. No public dashboard or Tailscale Serve route is needed.

## Pair devstation and sync ~/Box

The NixOS host's configuration was prepared separately, but activation was not
performed. Connect with `ssh devstation`, review pending changes in its `~/.dots`,
and follow that repository's rebuild guide before pairing.

Access the host dashboard from the Mac without conflicting with the Mac's port:

```sh
ssh -N -L 8385:127.0.0.1:8384 devstation
```

Open <http://127.0.0.1:8385> for devstation and port 8384 for the Mac. Exchange
IDs via **Actions → Show ID** and **Add Remote Device**, approving both ends.

On the Mac, add a folder with:

- Label: `Box`
- Folder ID: `box` (must match on both devices)
- Folder path: `~/Box`
- Folder type: **Send & Receive**
- Sharing: select devstation

Accept the invitation on devstation and explicitly choose its destination path.
Do not assume `/box` on the host is the intended destination: it contains
workspaces. Confirm the host path before accepting. If folder ID `box` already
exists on either side, inspect it before reusing it.

Back up existing files before the first sync. Start with a disposable file and
verify both directions. Enable file versioning on receiving devices as needed;
deletions propagate, and sync is not backup. Never let Box Drive or another
sync engine manage this same folder. Do not share keys, live databases, or
container runtime state.

## State

Mac identity, configuration, and index live in
`~/Library/Application Support/Syncthing/`. Preserve this directory outside Git.
The host uses `~/.local/state/syncthing/`. Each device needs its own identity;
do not copy one device's keys to the other.
