{ ... }:

{
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

        lap() {
          local name
          name="$(basename "$PWD" | sed -e 's/\\.//g')"
          if tmux ls 2>&1 | grep "$name"; then
            tmux attach -t "$name"
          elif [[ -f .envrc ]]; then
            direnv exec / tmux new-session -s "$name"
          else
            tmux new-session -s "$name"
          fi
        }

        tat() {
          lap "$@"
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
