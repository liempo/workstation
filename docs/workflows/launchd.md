# Launchd labels (System Settings)

This guide covers how macOS names launchd jobs in System Settings.
Path: System Settings → General → Login Items → App Background Activity.

macOS picks a display name from:

1. `AssociatedBundleIdentifiers` mapped to an `.app` display name (when Launch Services resolves it).
2. Otherwise the basename of `ProgramArguments[0]` (so `/bin/sh` shows as `sh`).

## What this repo does

| Item | Label | Settings name |
|------|-------|---------------|
| SSH key auto-load (home-manager) | `com.liempo.ssh-add-keys` | Workstation |
| nix-darwin activate-system | `com.liempo.activate-system` | `sh` (`/bin/sh` + `wait4path`, required at boot) |
| Determinate Nix daemon / store | `systems.determinate.*` | Determinate Systems (signed binaries) |
| Determinate nix-hook | `systems.determinate.nix-installer.nix-hook` | `sh` (installer plist, outside this flake) |

## Why two jobs show as `sh`

Early at boot, `/nix` may not be mounted yet.
nix-darwin and Determinate therefore start with:

```text
/bin/sh -c '/bin/wait4path /nix/... && exec …'
```

`/bin/sh` is always on the root volume.
The real work runs only after the store exists.

Do not set `ProgramArguments[0]` to a `/nix/store/...` wrapper for these boot jobs.
That path fails at boot with `EX_CONFIG`.
The same binary can still run later by hand.

## Stub app

`home/workstation.nix` installs `~/Applications/Workstation.app` with:

- `CFBundleIdentifier` = `com.liempo.workstation`
- `CFBundleDisplayName` = `Workstation`

Home-manager agents set:

```nix
AssociatedBundleIdentifiers = [ "com.liempo.workstation" ];
Label = "com.liempo.<agent>";
```

## nix-darwin prefix

`system/configuration.nix` sets:

```nix
launchd.labelPrefix = "com.liempo";
```

The next `drs` replaces old `org.nixos.*` plists.

## Remove a stale agent

If an old agent remains after rebuild:

1. Unload the user agent if it still exists:
   `launchctl bootout gui/$(id -u)/org.nix-community.home.ssh-add-keys 2>/dev/null || true`
2. Unload the system daemon if it still exists:
   `sudo launchctl bootout system/org.nixos.activate-system 2>/dev/null || true`

## Inspect Settings names

Run these checks when System Settings shows an unexpected name:

```bash
sfltool dumpbtm | grep -A8 'Name: sh'
plutil -p /Library/LaunchDaemons/com.liempo.activate-system.plist
plutil -p /Library/LaunchDaemons/systems.determinate.nix-installer.nix-hook.plist
```

## Limits

- Determinate owns `systems.determinate.nix-installer.nix-hook`. Do not retarget it at store binaries.
- nix-darwin `serviceConfig` has no freeform plist keys. System daemons cannot set `AssociatedBundleIdentifiers` without upstream changes.
- After you change executables, log out and log in (or reboot) if Settings still shows a stale name. BTM caches the old name.
