{ pkgs, settings, ... }:
{
  programs.git = {
    enable = true;
    userName = settings.user.fullName;
    userEmail = settings.user.email;

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = settings.user.editor;
      pull.rebase = true;
      url = {
        "https://github.com/" = {
          insteadOf = [ "gh:" "github:" ];
        };
        "git@github.com:juliamertz/" = {
          insteadOf = [ "julia:" ];
        };
      };
    };

    aliases = {
      s = "status";
      a = "add";
      c = "commit -m";

      wa = "worktree add";
      wr = "worktree remove";
      wl = "worktree list";
    };
  };
}
