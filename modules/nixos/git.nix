{ pkgs, ... }: {
  # Configure Git settings and directory switching
  programs.git = {
    enable = true;
    userName = "Jadeja Shaktisinh";
    userEmail = "shaktisinh.jadeja@qrolic.com";

    includes = [
      {
        # Whenever you are inside ~/work/ or its subfolders:
        condition = "gitdir:~/projects/";
        contents = {
          user.email = "bca2023shaktisinh1892@tnraocollege.org";
          core.sshCommand = "ssh -i ~/.ssh/id_github_personal -o IdentitiesOnly=yes";
        };
      }
      {
        # Optional: Explicitly enforce the personal key everywhere else
        condition = "gitdir:~/";
        contents = {
          core.sshCommand = "ssh -i ~/.ssh/id_github_work -o IdentitiesOnly=yes";
        };
      }
    ];
  };

  # Configure GitHub CLI to use these SSH keys automatically
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      credential_helper.hosts = [ "github.com" ];
    };
  };
}
