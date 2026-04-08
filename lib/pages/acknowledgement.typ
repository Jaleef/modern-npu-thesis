
#import "../utils/style.typ": 字号, 字体
#import "../layouts/preface.typ": preface-heading-style, preface-heading-above, preface-heading-below, preface-heading-font, preface-heading-size, preface-heading-weight

// 致谢页
#let acknowledgement(
  // documentclass 传入参数
  anonymous: false,
  twoside: false,
  doctype: "master",
  fonts: (:),
  // 其他参数
  title: auto,
  outlined: true,
  body,
) = {
  fonts = 字体 + fonts
  if title == auto {
    title = if doctype == "bachelor" { "致　　谢" } else { "致　谢" }
  }

  if not anonymous {
    pagebreak(weak: true, to: if twoside { "odd" })
    [
      #set text(font: fonts.宋体, size: 字号.小四)
      #set par(
        leading: if doctype == "bachelor" { 2.4pt } else { 0.9em },
        spacing: 0pt,
        justify: true,
        first-line-indent: if doctype == "bachelor" { (amount: 26pt, all: true) } else { (amount: 2em, all: true) },
      )

      // 使用统一的一级标题样式
      #show heading.where(level: 1, numbering: none): it => preface-heading-style(it, fonts)

      #v(preface-heading-above)
      #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>

      #body
    ]
  }
}
