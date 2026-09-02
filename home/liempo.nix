{
  impurity,
  dots,
  ...
}:

let
  dotconfig = "${dots}/home";
in
{
  imports = [
    ./workstation.nix
    ./git.nix
    ./shell.nix
    ./packages.nix
  ];

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
