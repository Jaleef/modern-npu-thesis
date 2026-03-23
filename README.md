# 西北工业大学学位论文 nwputhesis-typst

西北工业大学毕业论文（设计）的 Typst 模板，能够简洁、快速、持续生成 PDF 格式的毕业论文。

> 本模板基于 [modern-nju-thesis](https://github.com/nju-lug/modern-nju-thesis) 开发。

## 声明与风险

- Typst 是一门新生的排版语言，可能不如 Word 或 LaTeX 成熟。
- 该模板并非官方模板，而是民间开源项目，**存在不被认可的风险**。

## 优势与特性

- **语法简洁**：上手难度与 Markdown 相当，无需记忆繁琐的命令。
- **极速编译**：采用增量编译，长文档不影响编译速度。
- **环境搭建简单**：即开即用，无需配置数G的开发环境。支持现代编程语言特性（变量、函数、包管理等）。

## 使用说明

**你只需要修改 `thesis.typ` 文件即可，基本可以满足你的所有需求。**

### 本地开发（推荐）

1. 安装 VS Code 并安装 [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 插件。
2. 安装目录下的 `fonts` 文件夹中的推荐字体，防止字体缺失。
3. 将本项目作为工作区在 VS Code 中打开，打开 `thesis.typ` 文件。
4. 按下 `Ctrl + K V` 进行实时编辑和预览。

### 在线编辑

在 Typst 官方的 [Web App](https://typst.app/) 中新建项目并上传本项目文件。
注意：Web App 可能缺失部分特定中文字体，需要手动上传字体文件！

## 致谢

感谢所有 Typst 中文社区的贡献者以及南京大学 Typst 社区的优秀前置工作。

## License

MIT License
