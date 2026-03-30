{ gitUserName, gitUserEmail, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };

      init = {
        defaultBranch = "main";
      };

      core = {
        editor = "nvim";
        autocrlf = "input";
      };
    };
  };
}
