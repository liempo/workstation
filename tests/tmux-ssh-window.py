#!/usr/bin/env python3
"""Isolated tmux integration test; fake SSH, no network or live sessions."""
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
TMUX = shutil.which("tmux")
BASH = shutil.which("bash")
assert TMUX and BASH, "tmux and bash required"

with tempfile.TemporaryDirectory(prefix="tmux-ssh-test-") as directory:
    tmp = Path(directory)
    socket = str(tmp / "socket")
    env = dict(os.environ, PATH=f"{tmp}:{os.environ['PATH']}")
    env.pop("TMUX", None)
    env.pop("TMUX_PANE", None)

    def wrapper(name, body):
        path = tmp / name
        path.write_text(f"#!{BASH}\n{body}\n")
        path.chmod(0o755)

    wrapper("tmux", f"exec {shlex.quote(TMUX)} -S {shlex.quote(socket)} \"$@\"")
    wrapper("tmux-ssh-window", f"exec {shlex.quote(BASH)} "
            f"{shlex.quote(str(ROOT / 'home/scripts/tmux-ssh-window.sh'))} \"$@\"")
    wrapper("ssh", "printf 'FAKE_SSH'; printf ' <%s>' \"$@\"; printf '\\n'; exec sleep 120")

    def run(*args, **kwargs):
        return subprocess.run(args, env=env, text=True, capture_output=True,
                              check=True, **kwargs).stdout.strip()

    def tmux(*args):
        return run("tmux", *args)

    def wait_for(predicate):
        for _ in range(100):
            if predicate():
                return
            time.sleep(0.05)
        raise AssertionError("timed out")

    def ssh_panes(window, host, count):
        panes = tmux("list-panes", "-t", window, "-F", "#{pane_id}").splitlines()
        return len(panes) == count and all(
            f"FAKE_SSH <-t> <--> <{host}>" in tmux("capture-pane", "-p", "-t", p)
            for p in panes
        )

    try:
        local = tmux("-f", str(ROOT / "home/.config/tmux/tmux.conf"),
                     "new-session", "-d", "-s", "test", "-c", str(tmp),
                     "-P", "-F", "#{pane_id}")
        for key in ("S", "%", '"'):
            assert "tmux-ssh-window" in tmux("list-keys", "-T", "prefix", key)

        # Local split keeps the source directory and has no remote metadata.
        run("tmux-ssh-window", "split", local, "-h")
        assert len(tmux("list-panes", "-t", local).splitlines()) == 2
        assert not tmux("show-option", "-wqv", "-t", local, "@ssh-host")
        assert set(tmux("list-panes", "-t", local, "-F",
                        "#{pane_current_path}").splitlines()) == {str(tmp)}

        # Blank/cancel and shell-like input cannot create a window or execute.
        before = tmux("list-windows")
        run("tmux-ssh-window", "new", local, input="\n")
        run("tmux-ssh-window", "new", local, input="")
        for invalid in ("-oProxyCommand=bad", "host;touch /tmp/bad", "#{host}", "a b"):
            result = subprocess.run(["tmux-ssh-window", "new", local],
                                    input=invalid + "\n", env=env, text=True,
                                    capture_output=True)
            assert result.returncode == 1
        assert before == tmux("list-windows")

        # Separate remote windows retain separate hosts across both split axes.
        for host in ("devstation", "alec@other-host"):
            run("tmux-ssh-window", "new", local, input=host + "\n")
            window = tmux("display-message", "-p", "#{window_id}")
            wait_for(lambda: ssh_panes(window, host, 1))
            pane = tmux("list-panes", "-t", window, "-F", "#{pane_id}")
            assert tmux("show-option", "-wqv", "-t", pane, "@ssh-host") == host
            for count, axis in ((2, "-h"), (3, "-v")):
                run("tmux-ssh-window", "split", pane, axis)
                wait_for(lambda: ssh_panes(window, host, count))

        # A standard new-window from a remote window remains local.
        fresh = tmux("new-window", "-P", "-F", "#{pane_id}")
        assert not tmux("show-option", "-wqv", "-t", fresh, "@ssh-host")
        assert not tmux("show-option", "-wqv", "-t", local, "@ssh-host")
        print("PASS: bindings, local cwd, cancellation, input validation, SSH windows/splits, isolation")
    finally:
        subprocess.run([TMUX, "-S", socket, "kill-server"], env=env,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
