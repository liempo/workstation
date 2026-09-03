{config, ...}: {
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
        _tmux_auto_attach() {
          if [[ -n "$TMUX" || ! -o interactive ]]; then
            return 0
          fi

          if [[ "$TMUX_AUTO" == "0" ]]; then
            return 0
          fi

          if ! command -v tmux &>/dev/null; then
            return 0
          fi

          if [[ "$TMUX_AUTO_MAIN" == "1" ]]; then
            exec tmux new-session -A -s main
          fi

          if ! tmux has-session 2>/dev/null; then
            exec tmux new-session -s main
          fi

          if [[ ! -t 0 || ! -t 1 ]]; then
            exec tmux new-session -A -s main
          fi

          local choice session name i
          if command -v fzf &>/dev/null; then
            choice=$(
              printf '%s\n' \
                'Attach to main' \
                'Attach to session…' \
                'New session' \
                'Shell only (no tmux)' |
              fzf --height=40% --reverse --prompt='tmux> ' --header='tmux is already running'
            )
          else
            printf 'tmux running. [m]ain [l]ist [n]ew [s]hell? '
            read -k 1 choice
            echo
            case "''${choice:l}" in
              m) choice='Attach to main' ;;
              l) choice='Attach to session…' ;;
              n) choice='New session' ;;
              *) choice='Shell only (no tmux)' ;;
            esac
          fi

          case "$choice" in
            'Attach to main')
              exec tmux new-session -A -s main
              ;;
            'Attach to session…')
              if command -v fzf &>/dev/null; then
                session=$(tmux list-sessions -F '#{session_name}' | fzf --reverse --prompt='session> ')
              else
                tmux list-sessions
                printf 'Session name: '
                read -r session
              fi
              [[ -n "$session" ]] || return 0
              exec tmux attach-session -t "$session"
              ;;
            'New session')
              printf 'Session name (empty = auto): '
              read -r name
              if [[ -z "$name" ]]; then
                i=2
                name=main
                while tmux has-session -t "$name" 2>/dev/null; do
                  name="main-$i"
                  (( i++ ))
                done
              fi
              exec tmux new-session -s "$name"
              ;;
            *)
              return 0
              ;;
          esac
        }

        _tmux_auto_attach

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
