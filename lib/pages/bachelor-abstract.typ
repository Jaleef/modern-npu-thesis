#import "../utils/style.typ": 字号, 字体
#import "../format.typ": body-format, heading-format
#import "../layouts/preface.typ": preface-heading-style

// 西北工业大学本科生中文摘要页
#let bachelor-abstract(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  // 其他参数
  keywords: (),
  outline-title: "摘 要",
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
  if body-font == auto { body-font = fonts.宋体 }
  if body-size == auto { body-size = 字号.小四 }
  if leading == auto { leading = body-format.bachelor.leading }
  if spacing == auto { spacing = body-format.bachelor.spacing }
  if title-leading == auto { title-leading = heading-format.bachelor.leading.first() }
  if title-above == auto { title-above = heading-format.bachelor.above.first() }
  if title-below == auto { title-below = heading-format.bachelor.below.first() }

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set text(font: body-font, size: body-size)
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

    #text(font: body-font, size: body-size)[
      #text(font: fonts.黑体, weight: "regular")[关键词]：#(("",)+ keywords.intersperse("，")).sum()
    ]
  ]
}
