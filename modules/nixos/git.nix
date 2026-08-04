{ pkgs, ... }: {
  programs.git = {
    enable = true;
    # 1. Make your Work Profile the GLOBAL DEFAULT
    userName = "Jadeja Shaktisinh";
    userEmail = "shaktisinh.jadeja@qrolic.com";
    extraConfig = {
      core.sshCommand = "ssh -i ~/.ssh/id_github_work -o IdentitiesOnly=yes";
    };

    # 2. OVERRIDE explicitly for your personal projects
    includes = [
      {
        # Note the trailing slash: everything inside ~/projects/ gets this profile
        condition = "gitdir:~/projects/";
        contents = {
          user.email = "bca2023shaktisinh1892@tnraocollege.org";
          core.sshCommand = "ssh -i ~/.ssh/id_github_personal -o IdentitiesOnly=yes";
        };
      }
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}