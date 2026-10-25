# academic-writing-marketplace

一个自建的 Claude 插件市场，把几个**上游没有提供 Claude 插件清单**的插件/技能打包在一起，
让你能在 Claude Desktop 里通过 **设置 → Plugins → Add marketplace → GitHub repo** 一次性安装。

## 内容

| 插件 | 内容 | 上游 |
|---|---|---|
| `nature-skills` | 23 个 Nature 标准学术技能（含 nature-proposal-writer） | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) |
| `research-planning` | 5 个研究生命周期技能：literature-triage-matrix、gap-to-topic、research-design-helper、research-context-compressor、paper-memory-builder（纯 prompt，无需 Zotero/CLI） | [WenyuChiou/research-hub](https://github.com/WenyuChiou/research-hub) |
| `physics-thesis-revision` | 3 个理论物理/量子信息中文学位论文改稿技能：段落主旨与段间逻辑、摘要与第一章绪论、主张—证据审计（原创改写，例子按子系统 QFI 与纠缠判据重写） | 本仓库原创；方法来源见插件 README |
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

## 安装

1. 把本仓库推送到你的 GitHub（见下）。
2. Claude Desktop：**设置 → Plugins → Add marketplace → GitHub repo**，填 `<用户名>/<仓库名>`。
3. 在插件列表里安装需要的插件（推荐 `nature-skills` + `research-planning`）。

## 实时更新（自动同步上游）

`sync-upstream.sh` 会把每个上游的最新内容重新拉取并覆盖到本仓库；
`.github/workflows/sync-upstream.yml` 让它**每天 03:00 UTC 自动运行**，也可在
Actions 页面点 **Run workflow** 手动触发。

数据流：`上游仓库 → (每日 Action) → 本仓库 → (App 同步) → 你的 Claude`。

> 说明：App 对市场的同步是**周期性**的（启动/刷新时），不是秒级。所以"实时"= 无需你手动操作、
> 自动跟上游走，但存在同步延迟。上游有更新后，可在 App 里重新同步该市场以立即拉取。

手动同步（本地，需要 git）：

```bash
bash sync-upstream.sh
git add -A && git commit -m "sync upstream" && git push
```

## 首次推送到 GitHub

```bash
cd market
git init
git add .
git commit -m "academic writing marketplace"
git branch -M main
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git push -u origin main
```

推送后到仓库 **Settings → Actions → General**，确认 Workflow permissions 允许
**Read and write permissions**，否则自动同步无法回推。
