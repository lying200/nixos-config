# Agent 工作说明

本说明适用于整个仓库。

## 提交规范

- 提交前查看近期 `git log`，沿用仓库现有风格。
- 提交标题采用 Conventional Commits 格式：`type(scope): 中文描述`。
- `scope` 使用受影响的模块或功能名称，如 `core`、`dev-tools`、`wsl`、`niri`；跨模块或没有合适范围时可省略，使用 `type: 中文描述`。
- 常用类型：`feat` 表示新增功能或软件包，`fix` 表示修复问题，`refactor` 表示重构，`docs` 表示文档变更，`chore` 表示依赖更新或维护。
- 描述使用简洁中文，明确说明改动内容；软件名和技术标识保留原文。
- 每次提交聚焦一个主题，只暂存本次任务涉及的改动，保留用户已有的无关修改。

示例：

```text
feat(core): 为所有主机添加 sshpass
fix(compatibility): 为所有主机提供标准 Bash 路径
refactor: 重构主机配置架构与维护流程
docs: 添加 Agent 提交规范
```
