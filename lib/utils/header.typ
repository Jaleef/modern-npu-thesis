#import "../utils/style.typ": 字体, 字号

// ============================================
// 页眉统一配置
// ============================================
// 直接对齐 LaTeX 模板中的 geometry/fancyhdr 参数
#let graduate_header_ascent = 0.93cm
#let bachelor_header_ascent = 0.2cm
#let graduate_headsep = 0.11cm
#let bachelor_headsep = -0.1cm
#let bachelor_headrule = 0.8pt
#let graduate_headrule_thick = 3.4pt
#let graduate_headrule_thin = 0.6pt

// 页眉配置（用于 set page）
#let graduate-header-config = (
  header-ascent: graduate_header_ascent,
)

#let bachelor-header-config = (
  header-ascent: bachelor_header_ascent,
)

// 页眉渲染函数
#let header-render(content, fonts: (:)) = {
  fonts = 字体 + fonts
  [
    #set par(leading: 0pt, spacing: 0pt)
    #set text(font: fonts.宋体, size: 字号.小五)
    #align(center)[#content]
    #v(graduate_headsep)
    #line(length: 100%, stroke: graduate_headrule_thick + black)
    #v(-0.15em)
    #line(length: 100%, stroke: graduate_headrule_thin + black)
  ]
}

#let graduate-header-title(doctype) = {
  if doctype == "doctor" {
    "西北工业大学博士学位论文"
  } else {
    "西北工业大学硕士学位论文"
  }
}

#let bachelor-header-render() = {
  [
    #align(center)[
      #image("../../template/images/nwpuheader.png", width: 7cm)
    ]
    #v(bachelor_headsep)
    #line(length: 100%, stroke: bachelor_headrule + black)
  ]
}

#let add-blank-even-page(doctype: "master", fonts: (:), terminal: false) = {
  fonts = 字体 + fonts
  context {
    let current-page = counter(page).get().first()
    if calc.rem(current-page, 2) == 1 {
      pagebreak(weak: not terminal)
      set page(header: header-render([#graduate-header-title(doctype)], fonts: fonts))
      v(1fr)
    }
  }
}

#let break-to-odd-page(doctype: "master", fonts: (:)) = {
  fonts = 字体 + fonts
  context {
    let current-page = counter(page).get().first()
    if calc.rem(current-page, 2) == 1 {
      pagebreak()
      set page(header: header-render([#graduate-header-title(doctype)], fonts: fonts))
      v(1fr)
    }
    pagebreak()
  }
}
