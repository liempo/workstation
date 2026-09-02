{ pkgs, ... }:

{
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
    casks = [
      "arc"
      "ghostty"
      "tailscale-app"
    ];
  };

  # macOS preferences
  system.defaults = {
  };

  # Determinate installer manages Nix itself
  nix.enable = false;

  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
