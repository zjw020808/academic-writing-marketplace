# academic-writing-marketplace

一个自建的 Claude 插件市场，把几个**上游没有提供 Claude 插件清单**的插件/技能打包在一起，
让你能在 Claude Desktop 里通过 **设置 → Plugins → Add marketplace → GitHub repo** 一次性安装。

## 内容

| 插件 | 内容 | 上游 |
|---|---|---|
| `nature-skills` | 23 个 Nature 标准学术技能（含 nature-proposal-writer） | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) |
| `research-planning` | 5 个研究生命周期技能：literature-triage-matrix、gap-to-topic、research-design-helper、research-context-compressor、paper-memory-builder（纯 prompt，无需 Zotero/CLI） | [WenyuChiou/research-hub](https://github.com/WenyuChiou/research-hub) |
| `physics-thesis-revision` | 3 个理论物理/量子信息中文学位论文改稿技能：段落主旨与段间逻辑、摘要与第一章绪论、主张—证据审计（原创改写，例子按子系统 QFI 与纠缠判据重写） | 本仓库原创；方法来源见插件 README |
| `thesis-night-run` | 2 个论文工作流技能：`thesis-project-plan` 出阶段/任务/依赖/关键路径，`task-triage-night-run` 分级并排夜间清单与晨报 | 本仓库原创 |
| `writing-skills` | 4 个完整版写作技能：humanizer、humanizer-zh、anti-defensive-writing、anti-defensive-writing-zh（含 references/scripts） | blader / op7418 / Kiterlin / Devilyuu |
| `academic-research-skills` | ARS v3.23.0（5 技能） | [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) |

> ARS 也可以**直接**从上游安装（它自带 `marketplace.json`），Add marketplace → GitHub repo 填
> `Imbad0202/academic-research-skills` 即可。

### physics-thesis-revision

面向理论物理与量子信息方向的中文学位论文，三个技能：

- `section-logic-revision`：把每段压成“一段一句”的主旨链，检查段间承接与句子衔接。
- `abstract-introduction`：摘要按“问题—缺口—做法—结果—意义”一条主线；第一章按“背景—现状—缺口—本文内容”分工。
- `claim-evidence-review`：把断言绑定到定义、定理、证明、引用或可复算数值，标出方向、范围、强度、因果与术语越界。

这三个技能是**原创改写**，例子按子系统量子 Fisher 信息与纠缠判据重写，不包含上游文字或示例；方法来源在 `physics-thesis-revision/README.md` 注明。该插件不参与 `sync-upstream.sh` 的自动同步，升级时直接改仓库内文件。

### thesis-night-run

两个技能配合：`thesis-project-plan` 先把整轮工作拆成阶段—任务—交付物—验收—依赖—关键路径—负责人—模式—gate 的总规划；`task-triage-night-run` 再把可执行任务分成 T1 可自动、T2 需复核、Gated 必须等人三档，每个 gated 项写清 gate 原因与释放成本，生成夜间清单和晨报。夜间只读 `01`～`05`、只写 `06_讨论与确认/夜间批处理_日期/`，不碰 `07`/`08`、不改已确认正文与决策记录。配合 Claude Desktop 的定时任务使用；应用需保持打开，关掉则下次启动补跑。

### 最小市场（只装 thesis-night-run）

如果完整市场同步失败，又不想移除现有市场和已装插件，用仓库根目录的 `marketplace.json`。它只列 `thesis-night-run` 一个插件，市场名为 `thesis-night-run-marketplace`，与现有 `academic-writing-marketplace` 不重名，也不会覆盖已装的 `physics-thesis-revision`。

注意：**Marketplace URL 方式只下载 `marketplace.json`，不下载仓库里的插件目录**，所以插件源不能写相对路径，本目录用的是 `git-subdir` 对象源，指向本仓库的 `thesis-night-run` 子目录。

Claude Desktop → **Add marketplace → Marketplace URL**，填：

```
https://raw.githubusercontent.com/zjw020808/academic-writing-marketplace/main/marketplace.json
```

或 Gitee：

```
https://gitee.com/dr_wangchuan/academic-writing-marketplace/raw/main/marketplace.json
```

不需要移除任何现有市场；添加后只会出现 `thesis-night-run` 一个插件。Gitee 的 raw 地址也能读目录，但插件源固定指向 GitHub 仓库；如果 GitHub 不可达，需要把 `source.url` 改成 Gitee 仓库地址。

## 安装

1. 把本仓库推送到你的 Gitee（见下）。
2. Claude Desktop：**设置 → Plugins → Add marketplace → Git URL**，填
   `https://gitee.com/<用户名>/<仓库名>.git`。
   也可以选 **Marketplace URL**，填
   `https://gitee.com/<用户名>/<仓库名>/raw/main/.claude-plugin/marketplace.json`。
3. 在插件列表里安装需要的插件（推荐 `nature-skills` + `research-planning`；论文改稿用 `physics-thesis-revision`）。

## 实时更新（自动同步上游）

`sync-upstream.sh` 会把每个上游的最新内容重新拉取并覆盖到本仓库；
`.github/workflows/sync-upstream.yml` 让它**每天 03:00 UTC 自动运行**，也可在
Actions 页面点 **Run workflow** 手动触发。

> 注意：GitHub Actions 只在 GitHub 上运行；Gitee 不会执行该工作流。以 Gitee 为主仓库时，
> 需要手动运行 `bash sync-upstream.sh` 后提交并推送。

数据流：`上游仓库 → (每日 Action) → 本仓库 → (App 同步) → 你的 Claude`。

> 说明：App 对市场的同步是**周期性**的（启动/刷新时），不是秒级。所以"实时"= 无需你手动操作、
> 自动跟上游走，但存在同步延迟。上游有更新后，可在 App 里重新同步该市场以立即拉取。

手动同步（本地，需要 git）：

```bash
bash sync-upstream.sh
git add -A && git commit -m "sync upstream" && git push
```

## 首次推送到 Gitee

```bash
cd market
git init
git add .
git commit -m "academic writing marketplace"
git branch -M main
git remote add origin https://gitee.com/<你的用户名>/<仓库名>.git
git push -u origin main
```

Gitee 推送时用户名填 Gitee 用户名，密码填**私人令牌**（设置 → 安全设置 → 私人令牌），不是登录密码。仓库需设为公开，Claude Desktop 用 Git URL 拉取时不带你的登录凭据。

如果同时保留 GitHub 镜像，另加一个远端：

```bash
git remote add github https://github.com/<你的用户名>/<仓库名>.git
```

GitHub 侧的 **Settings → Actions → General** 需要允许 **Read and write permissions**，自动同步才能回推；Gitee 侧没有这个设置。
