{
  impurity,
  dots,
  ...
}: let
  dotconfig = "${dots}/home";
in {
  imports = [
    ./git.nix
    ./shell.nix
    ./packages.nix
  ];

  # Launchd user service; pair peers in the localhost GUI.
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    overrideDevices = false;
    overrideFolders = false;
    # Configure ~/Box (folder ID "box") in the GUI after pairing devstation.
    # Declaring the folder here would reset GUI-managed sharing on rebuild.
  };

  # ---------------------------------------------------------------------------
  # Dotfiles / XDG config (ghostty, nvim, tmux, IdeaVim)
  # Leave wiring here. Shell, git, and packages live in their own modules.
  # ---------------------------------------------------------------------------

  home.file.".ideavimrc".source = "${dotconfig}/.ideavimrc";

  xdg.configFile = {
    "ghostty" = {
      source = "${dotconfig}/.config/ghostty";
      recursive = true;
    };
    "nvim" = {
      # Whole directory as one link. recursive=true defeats impurity (per-file store copies).
      source = impurity.link "${dotconfig}/.config/nvim";
    };
    "tmux" = {
      source = "${dotconfig}/.config/tmux";
      recursive = true;
    };
  };

  home.stateVersion = "24.11";
}
