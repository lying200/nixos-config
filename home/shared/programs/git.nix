{ gitUserName, gitUserEmail, ... }:

{
  programs.git = {
    enable = true;

    # 使用新的 settings 语法
    settings = {
      # 1. 身份信息
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };

      # 2. 默认分支名
      init = {
        defaultBranch = "main";
      };

      # 3. 核心配置
      core = {
        editor = "vim";       # 默认编辑器
        autocrlf = "input";   # 处理换行符
      };
    };
  };
}
