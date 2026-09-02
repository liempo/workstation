{ lib, workstationBundleId, ... }:

let
  gitAccounts = {
    personal = {
      name = "Alec";
      email = "gonzalesalec@gmail.com";
      gitdirs = [
        "~/Development/personal/"
        "~/.dots/" # dotfiles repo — outside Development, personal owner
      ];
      sshKey = "id_ed25519_personal";
    };
    astra = {
      name = "Alec";
      email = "alec@astraapplications.com";
      gitdir = "~/Development/astra/";
      sshKey = "id_ed25519_astra";
    };
  };

  mkGitSshCommand = key: "ssh -i ~/.ssh/${key} -o IdentitiesOnly=yes";

  mkAccountInclude =
    account: gitdir: {
      condition = "gitdir:${gitdir}";
      contents = {
        user = {
          name = account.name;
          email = account.email;
        };
        core.sshCommand = mkGitSshCommand account.sshKey;
      };
    };

  sshKeys = lib.unique (
    lib.map (account: account.sshKey) (lib.attrValues gitAccounts)
  );
in
{
  _module.args = {
    inherit gitAccounts;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = gitAccounts.personal.name;
        email = gitAccounts.personal.email;
      };
      core.sshCommand = mkGitSshCommand gitAccounts.personal.sshKey;
    };
    includes =
      lib.concatMap (gitdir: [ (mkAccountInclude gitAccounts.personal gitdir) ])
        gitAccounts.personal.gitdirs
      ++ [ (mkAccountInclude gitAccounts.astra gitAccounts.astra.gitdir) ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "yes";
      UseKeychain = true;
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

  # Load SSH keys at login; passphrase stored in macOS Keychain after first add
  programs.zsh.profileExtra = ''
    for key in ${lib.concatStringsSep " " (map (k: "$HOME/.ssh/${k}") sshKeys)}; do
      [[ -f "$key" ]] && ssh-add --apple-use-keychain "$key" 2>/dev/null
    done
  '';

  # Load SSH keys into agent at graphical login (Keychain must be unlocked).
  # Label + AssociatedBundleIdentifiers → System Settings shows "Workstation".
  launchd.agents.ssh-add-keys = {
    enable = true;
    waitForNixStore = false;
    config = {
      Label = "com.liempo.ssh-add-keys";
      AssociatedBundleIdentifiers = [ workstationBundleId ];
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''for key in ${lib.concatStringsSep " " (map (k: "\"$HOME/.ssh/${k}\"") sshKeys)}; do [ -f "$key" ] && /usr/bin/ssh-add --apple-use-keychain "$key" 2>/dev/null; done''
      ];
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
    };
  };
}
