# 西北工业大学学位论文 `modern-npu-thesis`

西北工业大学学位论文 Typst 模板。

仓库结构参考了 [pkuthss-typst](https://github.com/pku-typst/pkuthss-typst) 的组织方式：根目录保留用户入口，内部实现集中到 `lib/`，模板初始化内容单独放在 `template/`。

> 如果你想使用 LaTeX 版本，请参考 [nwputhesis](https://github.com/1195343015/nwputhesis)。

## 使用方式

### 方式一：本地克隆仓库开发

1. 克隆本仓库。
2. 打开根目录的 [thesis.typ](thesis.typ)。
3. 直接修改内容并编译。

示例命令：

```bash
typst compile thesis.typ --font-path fonts
```

如果你是在仓库里直接编译 [template/main.typ](template/main.typ)，还需要显式指定本地包缓存目录；否则 Typst 会尝试联网下载 `@preview/modern-npu-thesis:0.1.0`。

```bash
typst compile --root . --package-cache-path .typst/packages --font-path fonts template/main.typ
```

### 方式二：作为 Typst 模板使用

- [template.typ](template.typ) 是包入口。
- [template/main.typ](template/main.typ) 是模板初始化入口。

模板初始化得到的是一个精简项目；根目录的 [thesis.typ](thesis.typ) 仅用于本仓库开发、调试和 CI。

## 目录结构

- [template.typ](template.typ)：包入口，导出模板 API。
- [thesis.typ](thesis.typ)：仓库内示例论文入口。
- [template/](template)：`typst init` 使用的模板目录。
- [lib/](lib)：内部实现，按 `layouts`、`pages`、`utils` 分层。
- [fonts/](fonts)：仓库附带字体，便于跨平台编译。

## 本地开发

仓库已提供工作区配置 [.vscode/settings.json](.vscode/settings.json)，Tinymist 会默认追加：

- `--package-cache-path .typst/packages`
- `--font-path fonts`

## License

MIT License
