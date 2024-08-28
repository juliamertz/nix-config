{ settings, ... }:
let inherit (settings) user;
in {
  home.programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;

    aliases = {
      s = "status";
      a = "add";
      c = "commit -m";

      wa = "worktree add";
      wr = "worktree remove";
      wl = "worktree list";
    };

    extraConfig =
      # ini
      ''
        [core]
        editor = "nvim"

        [init]
        defaultBranch = "main"

        [pull]
        rebase = true

        [url "git@github.com:juliamertz/"]
        insteadOf = "julia:"

        [url "https://github.com/"]
        insteadOf = "gh:"
        insteadOf = "github:"
      '';
  };
}
