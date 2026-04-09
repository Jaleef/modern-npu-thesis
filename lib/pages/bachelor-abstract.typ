#import "../utils/custom-cuti.typ": fakebold
#import "../utils/style.typ": 字号, 字体
#import "../utils/double-underline.typ": double-underline
#import "../layouts/preface.typ": preface-heading-style

// 西北工业大学本科生中文摘要页
#let bachelor-abstract(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  funding: none,
  outline-title: "摘 要",
  outlined: false,
  anonymous-info-keys: ("author", "supervisor", "supervisor-ii"),
  leading: 2.4pt,
  spacing: 0pt,
  title-leading: 2.4pt,
  title-above: 0pt,
  title-below: 0pt,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "西北工业大学毕业论文"),
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  内置辅助函数
  let info-value(key, body) = {
    if not anonymous or (key not in anonymous-info-keys) {
      body
    }
  }

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set text(font: fonts.宋体, size: 字号.小四)
    #set par(leading: leading, justify: true, spacing: spacing)

    // 使用统一的一级标题样式
    #show heading.where(level: 1): it => preface-heading-style(
      it,
      fonts,
      leading: title-leading,
      below: title-below,
    )
    #v(title-above)
    #heading(level: 1, outlined: outlined, outline-title)

    #[
      #set par(first-line-indent: (amount: 26pt, all: true))

      #body
    ]

    #v(1em)

    #text(font: fonts.宋体, size: 字号.小四)[
      #text(font: fonts.黑体, weight: "regular")[关键词]：#(("",)+ keywords.intersperse("，")).sum()
    ]
  ]
}
