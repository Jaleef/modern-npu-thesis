#import "../utils/style.typ": 字号, 字体
#import "../format.typ": body-format, heading-format
#import "../layouts/preface.typ": preface-heading-style

// 西北工业大学本科生英文摘要页
#let bachelor-abstract-en(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "ABSTRACT",
  outlined: false,

  leading: auto,
  spacing: auto,
  body-font: auto,
  body-size: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  if body-font == auto { body-font = "Times New Roman" }
  if body-size == auto { body-size = 字号.小四 }
  if leading == auto { leading = body-format.bachelor.leading }
  if spacing == auto { spacing = body-format.bachelor.spacing }
  if title-leading == auto { title-leading = heading-format.bachelor.leading.first() }
  if title-above == auto { title-above = heading-format.bachelor.above.first() }
  if title-below == auto { title-below = heading-format.bachelor.below.first() }
  info = (
    title-en: "NPU Thesis Template for Typst",
    author-en: "Zhang San",
    department-en: "XX School",
    major-en: "XX",
    supervisor-en: "Li Si",
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  // 3.  正式渲染
  [
    #pagebreak(weak: true, to: if twoside { "odd" })

    #set text(font: body-font, size: body-size)
    #set par(leading: leading, justify: true, spacing: spacing)

    // 英文摘要标题，字号和间距使用统一配置
    #show heading.where(level: 1): it => {
      set text(font: "Times New Roman", size: 字号.三号, weight: "regular")
      set par(leading: title-leading, spacing: 0pt)
      set block(above: 0pt, below: title-below)
      align(center, it)
    }
    #v(title-above)
    #heading(level: 1, outlined: outlined, outline-title)

    #[
      #set par(first-line-indent: (amount: 26pt, all: true))

      #body
    ]

    #v(1em)

    #text(font: body-font, size: body-size)[
      #text(weight: "bold")[KEY WORDS]#text(font: fonts.宋体)[：]#(("",)+ keywords.intersperse(", ")).sum()
    ]
  ]
}
