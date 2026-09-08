# Packaged by home/shell.nix as tmux-ssh-window (Bash).
set -euo pipefail

case "${1:-}" in
  new)
    origin=${2:?missing origin pane}
    printf 'SSH hostname or alias (e.g. devstation; blank cancels): '
    IFS= read -r host || exit 0
    [[ -n "$host" ]] || exit 0
    # Accept destinations, not SSH flags, shell commands, or tmux formats.
    # Ports, identities, and ProxyJump belong in ~/.ssh/config.
    if [[ ! "$host" =~ ^[[:alnum:]_:][[:alnum:]_.:@%-]*$ ]]; then
      printf 'Invalid destination. Use a hostname, SSH alias, or user@host.\n' >&2
      exit 1
    fi
    # Multiple command arguments make tmux exec directly, without a shell.
    session=$(tmux display-message -p -t "$origin" '#{session_id}')
    tmux new-window -t "$session:" -n "ssh:$host" \
      tmux-ssh-window connect "$host"
    ;;
  connect)
    host=${2:?missing host}
    tmux set-option -w -t "$TMUX_PANE" @ssh-host "$host"
    tmux set-option -w -t "$TMUX_PANE" automatic-rename off
    # Keep connection failures visible; successful logout closes the pane.
    tmux set-option -w -t "$TMUX_PANE" remain-on-exit failed
    exec ssh -t -- "$host"
    ;;
  split)
    pane=${2:?missing pane}
    direction=${3:?missing split direction}
    [[ "$direction" == -h || "$direction" == -v ]] || exit 1
    host=$(tmux show-option -wqv -t "$pane" @ssh-host)
    if [[ -n "$host" ]]; then
      tmux split-window "$direction" -t "$pane" ssh -t -- "$host"
    else
      cwd=$(tmux display-message -p -t "$pane" '#{pane_current_path}')
      tmux split-window "$direction" -t "$pane" -c "$cwd"
    fi
    ;;
  *)
    printf 'Usage: tmux-ssh-window {new PANE | connect HOST | split PANE -h|-v}\n' >&2
    exit 1
    ;;
esac
