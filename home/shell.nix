{ config, ... }:

{
  # Android Studio default SDK; platform-tools provides `adb` after SDK setup.
  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Library/Android/sdk";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/Library/Android/sdk/platform-tools"
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
        theme = "agnoster";
        plugins = [
          "git"
        ];
      };
      initContent = ''
        # Interactive shells always join (or create) the fixed `main` tmux session.
        if [[ -z "$TMUX" && -o interactive ]]; then
          exec tmux new-session -A -s main
        fi

        bindkey '^J' down-line-or-history
        bindkey '^K' up-line-or-history
        bindkey '^L' forward-char
        bindkey '^H' backward-char

        prompt_context() {
          if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
            prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
          fi
        }

        vact() {
          if [[ -z "$VIRTUAL_ENV" ]]; then
            if [[ -d ./.venv ]]; then
              source ./.venv/bin/activate
            fi
          else
            parentdir="$(dirname "$VIRTUAL_ENV")"
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
