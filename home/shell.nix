{config, pkgs, ...}: {
  # Android Studio default SDK; platform-tools provides `adb` after SDK setup.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Library/Android/sdk";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/Library/Android/sdk/platform-tools"
  ];

  # Use the existing tmux/OpenSSH packages; no TPM or SSH plugins.
  home.packages = [
    (pkgs.writeShellApplication {
      name = "tmux-ssh-window";
      runtimeInputs = [ pkgs.tmux pkgs.openssh ];
      text = builtins.readFile ./scripts/tmux-ssh-window.sh;
    })
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "afowler";
        plugins = [
          "git"
        ];
      };
      initContent = ''
        # Make Homebrew tools (including Podman) available in interactive shells.
        export PATH="/opt/homebrew/bin:$PATH"

        # Route Docker API clients (e.g. Supabase) to the Podman VM.
        export DOCKER_HOST="unix://$(podman machine inspect podman-machine-default --format '{{.ConnectionInfo.PodmanSocket.Path}}')"

        tat() {
          if [[ -n "$TMUX" || ! -o interactive ]]; then
            return 0
          fi

          if ! command -v tmux &>/dev/null; then
            return 0
          fi

          local directory name
          directory=$(pwd -P) || return 1
          name="$directory"
          if [[ "$directory" == "$HOME" ]]; then
            name='~'
          elif [[ "$directory" == "$HOME/"* ]]; then
            name="~/''${directory#"$HOME/"}"
          fi
          # Tmux reserves dots and colons in session names.
          name="''${name//[.:]/_}"
          exec tmux new-session -A -s "$name" -c "$directory"
        }

        bindkey '^J' down-line-or-history
        bindkey '^K' up-line-or-history
        bindkey '^L' forward-char
        bindkey '^H' backward-char

        vact() {
          if [[ -z "$VIRTUAL_ENV" ]]; then
            if [[ -d ./.venv ]]; then
              source ./.venv/bin/activate
            fi
          else
            local parentdir="$(dirname "$VIRTUAL_ENV")"
            if [[ "$PWD"/ != "$parentdir"/* ]]; then
              deactivate
            fi
          fi
        }

        drs() {
          if [[ "$1" == "--impure" ]]; then
            shift
            IMPURITY_PATH="$HOME/.dots" sudo --preserve-env=IMPURITY_PATH \
              darwin-rebuild switch --flake "$HOME/.dots#workstation-impure" --impure "$@"
          else
            sudo darwin-rebuild switch --flake "$HOME/.dots#workstation" "$@"
          fi
        }
      '';
    };
  };
}
