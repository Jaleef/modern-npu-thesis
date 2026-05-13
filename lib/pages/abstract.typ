#import "../utils/style.typ": 字体
#import "../deps.typ": zh

// 摘要页
// abstract: 摘要字典，包含 content、keywords、funding
// title: 页面和页眉显示的标题（默认使用 outline-title）
// outline-title: 目录中显示的标题
#let abstract-page(
  abstract: (:),
  keyword-label: "关键词",
  keyword-weight: "regular",
  keyword-sep: "；",
  keyword-indent: true,
  outline-title: "摘　要",
  title: none,
  outlined: true,
) = {
  let page-title = if title != none { title } else { outline-title }
  let keywords = abstract.at("keywords", default: ())
  let funding = abstract.at("funding", default: none)
  let content = abstract.at("content", default: [])

  heading(level: 1, outlined: outlined, page-title)

  content

  [
    #set par(first-line-indent: 0pt)
    #v(1em)
    #let indent = if keyword-indent { 2em } else { 0pt }
    #{
      let label = if keyword-weight == "bold" {
        text(font: 字体.黑体混排, weight: "bold")[#keyword-label：]
      } else {
        [#h(indent)#text(font: 字体.黑体混排)[#keyword-label]：]
      }
      label + (("",) + keywords.intersperse(keyword-sep)).sum()
    }

    #if funding != none [
      #v(1fr)
      #text(zh(5))[#h(indent)#funding]
    ]
  ]
}
