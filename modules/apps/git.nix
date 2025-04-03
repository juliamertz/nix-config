{
  lib,
  settings,
  pkgs,
  ...
}:
let
  gitConfig = lib.generators.toGitINI {
    init.defaultBranch = "main";
    core.editor = "nvim";
    pull.rebase = true;

    alias = {
      s = "status";
      a = "add";
      c = "commit -m";

      wa = "worktree add";
      wr = "worktree remove";
      wl = "worktree list";
    };

    url = {
      "https://github.com/" = {
        insteadOf = [
          "gh:"
          "github:"
        ];
      };
      "git@github.com:juliamertz/" = {
        insteadOf = [ "julia:" ];
      };
    };

    user = with settings.user; {
      inherit email;
      name = fullName;
    };
  };

in
{
  home.file.".gitconfig".text = gitConfig;
  environment.systemPackages = with pkgs; [
    git
    gh
  ];
}
