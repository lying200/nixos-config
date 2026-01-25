{ userFullName, userEmail, ... }:

{
  programs.git = {
    enable = true;

    config = {
      # 1. 身份信息
      user = {
        name = userFullName;
        email = userEmail;
      };

      # 2. 默认分支名
      init = {
        defaultBranch = "main";
      };

      core = {
        editor = "vim";       # 默认编辑器
        autocrlf = "input";   # 处理换行符
      };
    };
  };
}
