{pkgs, ...}: {
  system.primaryUser = "liempo";

  # CLI tools (replaces brew install)
  environment.systemPackages = with pkgs; [
    pi-coding-agent
    tmux
    neovim
    zoxide
    fzf
    ripgrep
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # GUI apps (declarative Homebrew)
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      {
        name = "abue-ammar/tinycast";
        trusted = true; # Homebrew 6+ HOMEBREW_REQUIRE_TAP_TRUST
      }
    ];
    casks = [
      "arc"
      "ghostty"
      "stats"
      "tailscale-app"
      "android-studio"
      "tinycast" # abue-ammar/tinycast — macOS 26 Tahoe, arm64
      "zoom"
    ];
    # Xcode: install manually from the App Store (not masApps — mas re-downloads on drs).
  };

  # nix-darwin launchd labels: com.liempo.* (was org.nixos.*)
  # System daemons must use /bin/sh + wait4path (store paths are not
  # executable until /nix is mounted). Login Items therefore show "sh".
  launchd.labelPrefix = "com.liempo";

  # Undo a previous cosmetic rewrite of Determinate's nix-hook to a store
  # binary (breaks early boot). No-op once ProgramArguments[0] is /bin/sh.
  # Also: keep Spotlight indexing off; reload symbolic hotkeys after defaults write.
  system.activationScripts.postActivation.text = ''
    plist=/Library/LaunchDaemons/systems.determinate.nix-installer.nix-hook.plist
    if [[ -f "$plist" ]]; then
      current=$(/usr/bin/plutil -extract ProgramArguments.0 raw "$plist" 2>/dev/null || true)
      if [[ "$current" == */bin/nix-installer-hook ]]; then
        echo "restoring Determinate nix-hook to /bin/sh + wait4path" >&2
        /usr/bin/plutil -replace ProgramArguments -json '["/bin/sh","-c","/bin/wait4path /nix/nix-installer && /nix/nix-installer repair"]' "$plist"
        /bin/launchctl bootout system/systems.determinate.nix-installer.nix-hook 2>/dev/null || true
        /bin/launchctl bootstrap system "$plist" 2>/dev/null || true
      fi
    fi

    echo "disabling Spotlight indexing" >&2
    /usr/bin/mdutil -a -i off >/dev/null 2>&1 || true

    /usr/bin/sudo -u liempo /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
  '';

  # macOS preferences: Stage Manager + native tiling (no third-party WM)
  system.defaults.WindowManager = {
    GloballyEnabled = true;
    AppWindowGroupingBehavior = true;
    AutoHide = false;

    EnableTilingByEdgeDrag = true;
    EnableTopTilingByEdgeDrag = true;
    EnableTilingOptionAccelerator = true;
    EnableTiledWindowMargins = true;
  };

  # ⌘` toggles Stage Manager (222); frees ⌘Space from Spotlight for Tinycast
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys" = {
    AppleSymbolicHotKeys = {
      "27" = {
        enabled = false;
        value = {
          parameters = [
            96
            50
            1048576
          ];
          type = "standard";
        };
      };
      # Spotlight Search (⌘Space)
      "64" = {
        enabled = false;
      };
      # Finder search window (⌘⌥Space)
      "65" = {
        enabled = false;
      };
      "222" = {
        enabled = true;
        value = {
          parameters = [
            96
            50
            1048576
          ];
          type = "standard";
        };
      };
    };
  };

  # Determinate installer manages Nix itself
  nix.enable = false;

  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
