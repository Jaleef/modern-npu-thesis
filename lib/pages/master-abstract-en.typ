#import "../utils/style.typ": 字体, 字号
#import "../format.typ": body-format, heading-format
#import "../utils/header.typ": header-render
#import "../layouts/preface.typ": (
  preface-heading-style, preface-body-first-line-indent,
  preface-keywords-above,
)

#let master-abstract-en(
  doctype: "master",
  degree: "academic",
  twoside: false,
  fonts: (:),
  info: (:),
  keywords: (),
  outline-title: "Abstract",
  outlined: true,

  leading: auto,
  spacing: auto,
  body-font: auto,
  body-size: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  keywords-above: preface-keywords-above,
  funding: none,
  body,
) = {
  fonts = 字体 + fonts
  if body-font == auto { body-font = "Times New Roman" }
  if body-size == auto { body-size = 字号.小四 }
  if leading == auto { leading = body-format.graduate.leading }
  if spacing == auto { spacing = body-format.graduate.spacing }
  if title-leading == auto { title-leading = heading-format.graduate.leading.first() }
  if title-above == auto { title-above = heading-format.graduate.above.first() }
  if title-below == auto { title-below = heading-format.graduate.below.first() }
  info = (
    (
      title-en: "NPU Thesis Template for Typst",
      author-en: "Zhang San",
      department-en: "XX School",
      major-en: "XX",
      supervisor-en: "Li Si",
    )
      + info
  )

  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  pagebreak(weak: true, to: if twoside { "odd" })


  [
    #set par(leading: leading, spacing: spacing, justify: true)

    // 英文摘要标题复用统一标题样式，只覆盖字体与字重
    #show heading.where(level: 1): it => {
      preface-heading-style(
        it,
        fonts,
        font: "Times New Roman",
        weight: "bold",
        leading: title-leading,
        below: title-below,
      )
    }
    #v(title-above)
    #metadata(none) <__nwpu_master_abstract_en_heading_start__>
    #heading(level: 1, outlined: outlined, outline-title)
    #metadata(none) <__nwpu_master_abstract_en_heading_end__>

    #[
      #set text(font: body-font, size: body-size)
      #set par(first-line-indent: preface-body-first-line-indent)
      #body
    ]

#v(keywords-above)
#text(font: body-font, size: body-size)[
  #strong[Key words]#text(font: fonts.黑体, weight: "bold")[：]#(("",) + keywords.intersperse("; ")).sum()
]

    #v(1fr)

    #if funding != none [
      #set par(leading: 1.4em)
      #text(font: fonts.宋体, size: 字号.五号)[#funding]
    ]
  ]
}
