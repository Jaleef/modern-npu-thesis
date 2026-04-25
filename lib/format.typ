// 集中管理所有排版格式参数
// 当学校格式要求变动时，只需修改本文件即可
//
// 参数按排版类别组织，与学校论文格式规范的章节对应：
//   1. 页面格式 → page-format
//   2. 页眉格式 → header-format
//   3. 正文格式 → body-format
//   4. 标题格式 → heading-format（正文与前置部分共用）
//   5. 图表标题格式 → caption-format

#import "utils/style.typ": 字号

// =========================================================
// 1. 页面格式
// =========================================================
#let page-format = (
  paper: "a4",
  // 研究生：上下 2.54cm，左右 2.5cm
  graduate-margin: (top: 2.54cm, bottom: 2.54cm, left: 2.5cm, right: 2.5cm),
  // 本科生：上下 2.54cm，左右 3.18cm
  bachelor-margin: (top: 2.54cm, bottom: 2.54cm, left: 3.18cm, right: 3.18cm),
)

// =========================================================
// 2. 页眉格式
// =========================================================
#let header-format = (
  graduate: (
    ascent: 0.9cm,
    headsep: -0.22cm,
    headrule-offset: 0.4cm,
    headrule-thick: 3.2pt,
    headrule-thin: 0.6pt,
    headrule-gap: 0.32em,
  ),
  bachelor: (
    ascent: 0.4cm,
    headsep: 0.04cm,
    headrule: 0.8pt,
  ),
)

// =========================================================
// 3. 正文格式
// =========================================================
#let body-format = (
  graduate: (
    leading: 10pt,
    spacing: 10pt,
    first-line-indent: (amount: 2em, all: true),
  ),
  bachelor: (
    leading: 10pt,
    spacing: 10pt,
    first-line-indent: (amount: 26pt, all: true),
  ),
)

// =========================================================
// 4. 标题格式（正文章节标题，按级别）
// =========================================================
#let heading-format = (
  graduate: (
    size: (字号.三号, 字号.四号, 字号.小四),
    weight: ("regular", "regular", "regular"),
    leading: (10pt, 10pt, 10pt),
    above: (2 * 14pt - 0.7em, 16pt, 16pt),
    below: (2 * 17pt - 0.7em, 12pt, 12pt),
  ),
  bachelor: (
    size: (字号.三号, 字号.四号, 字号.小四),
    weight: ("regular", "regular", "regular"),
    leading: (10pt, 10pt, 10pt),
    above: (28pt, 12pt, 12pt),
    below: (28pt, 12pt, 12pt),
  ),
)

// =========================================================
// 5. 图表标题格式
// =========================================================
#let caption-format = (
  size: 字号.五号,
  separator: "  ",
)
