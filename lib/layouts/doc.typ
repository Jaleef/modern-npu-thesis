// 文稿设置，可以进行一些像页面边距这类的全局设置
#import "../utils/style.typ": 字体, 字号
#import "../utils/header.typ": bachelor-header-config
#import "@preview/cuti:0.4.0": show-cn-fakebold
#import "../format.typ": page-format, header-format

#let doc(
  doctype: "bachelor",
  graduate_header_ascent: header-format.graduate.ascent,
  lang: "zh",
  margin: auto,
  it,
) = {
  // 设置页面边距
  let page-margin = if margin == auto {
    if doctype == "graduate" {
      page-format.graduate-margin
    } else {
      page-format.bachelor-margin
    }
  } else {
    margin
  }

  show: show-cn-fakebold
  set text(font: 字体.宋体, size: 字号.小四, lang: lang)
  set par(leading: 12pt, spacing: 12pt)
  set align(center)
  set table(stroke: none, align: center, inset: (x: 0pt, y: 4pt))
  set page(
    paper: "a4",
    margin: page-margin,
    ..(
      if doctype == "graduate" {
        (header-ascent: graduate_header_ascent)
      } else {
        bachelor-header-config
      }
    ),
  )

  it
}
