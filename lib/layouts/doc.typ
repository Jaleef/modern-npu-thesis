// 文稿设置，可以进行一些像页面边距这类的全局设置
#import "../deps.typ": show-cn-fakebold, zh
#import "../utils/style.typ": 字体

#let doc(
  margin: auto,
  it,
) = {
  show: show-cn-fakebold
  set text(zh(4.5), font: 字体.宋体混排, lang: "zh")
  set par(leading: 12pt, spacing: 12pt)
  set align(center)
  set table(stroke: none, align: center, inset: (x: 0pt, y: 4pt))
  set page(
    paper: "a4",
    margin: margin,
  )

  it
}
