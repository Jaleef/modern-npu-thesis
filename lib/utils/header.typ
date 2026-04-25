#import "../utils/style.typ": 字体, 字号
#import "../format.typ": header-format

// ============================================
// 页眉统一配置
// ============================================
// 所有数值来自 format.typ，修改格式请编辑该文件

// 页眉配置（用于 set page）
#let graduate-header-config = (
  header-ascent: header-format.graduate.ascent,
)

#let bachelor-header-config = (
  header-ascent: header-format.bachelor.ascent,
)

// 页眉渲染函数
#let header-render(
  content,
  fonts: (:),
  graduate_headsep: header-format.graduate.headsep,
  graduate_headrule_offset: header-format.graduate.headrule-offset,
  graduate_headrule_thick: header-format.graduate.headrule-thick,
  graduate_headrule_thin: header-format.graduate.headrule-thin,
  graduate_headrule_gap: header-format.graduate.headrule-gap,
) = {
  fonts = 字体 + fonts
  [
    #set par(leading: 0pt, spacing: 0pt)
    #set text(font: fonts.宋体, size: 字号.小五)
    #align(center)[#content]
    #v(graduate_headsep)
    #move(dy: graduate_headrule_offset)[
      #line(length: 100%, stroke: graduate_headrule_thick + black)
      #v(graduate_headrule_gap)
      #line(length: 100%, stroke: graduate_headrule_thin + black)
    ]
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
    #set par(leading: 0pt, spacing: 0pt)
    #align(center)[
      #image("../../template/figures/nwpuheader.png", width: 7cm)
    ]
    #v(header-format.bachelor.headsep)
    #line(length: 100%, stroke: header-format.bachelor.headrule + black)
  ]
}
