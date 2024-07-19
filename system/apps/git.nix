{ settings, ... }:
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = settings.user.fullName;
        email = settings.user.email;
      };
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
      alias = {
        s = "status";
        a = "add";
        c = "commit -m";

        wa = "worktree add";
        wr = "worktree remove";
        wl = "worktree list";
      };
    };

  };
}
