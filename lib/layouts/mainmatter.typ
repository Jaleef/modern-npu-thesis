#import "../deps.typ": cap-style, capfig-style, captab-style, style-algorithm, zh
#import "../utils/style.typ": 字体
#import "../utils/custom-numbering.typ": show-equation-handler
#import "header.typ": page-footer, page-header-footer
#import "../format.typ": caption-format, line-spacing

#let mainmatter(
  graduate: false,
  degree: "master",
  english-writing: false,
  leading: line-spacing.bachelor,
  spacing: line-spacing.bachelor,
  heading-above: (),
  heading-below: (),
  heading-numbering: none,
  it,
) = {
  // 算法三线表样式
  show: style-algorithm.with(
    caption-style: body => text(zh(5), strong(body)),
    hlines: (
      grid.hline(stroke: 1.5pt + black),
      grid.hline(stroke: 1pt + black),
      grid.hline(stroke: 1.5pt + black),
    ),
  )

  // 页眉页脚
  show: page-header-footer.with(graduate: graduate, degree: degree)

  // 文本和段落样式
  set align(left)
  set par(
    leading: leading,
    justify: true,
    first-line-indent: (amount: 2em, all: true),
    spacing: spacing,
  )

  set math.equation(supplement: if english-writing { [Equation] } else { [式] })
  show math.equation.where(block: true): show-equation-handler(graduate)


  // 处理标题
  set heading(numbering: heading-numbering)
  show heading: it => {
    if it.level == 1 {
      counter(figure.where(kind: "algorithm")).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }

    set text(
      font: 字体.黑体混排,
      size: (zh(3), zh(4), zh(4.5)).at(calc.min(it.level, 3) - 1),
      weight: "regular",
    )
    set par(first-line-indent: (amount: 0pt))

    let above-extra = if it.level <= heading-above.len() { heading-above.at(it.level - 1) } else { 0pt }
    let below-extra = if it.level <= heading-below.len() { heading-below.at(it.level - 1) } else { 0pt }

    // 一级标题统一换页并居中
    if it.level == 1 {
      pagebreak(weak: true, to: if graduate { "odd" })
      v(leading + above-extra)
      align(center, block(below: leading + below-extra, it))
    } else {
      block(above: leading + above-extra, below: spacing + below-extra, it)
    }
  }

  // cap-able 全局样式（共享参数）
  show: cap-style.with(
    numbering-format: "1-1",
    use-chapter: true,
    caption-size: caption-format.size,
    pre-supplement-number-spacing: if english-writing { 0.3em } else { 0em },
  )

  // 表格样式
  show table: set par(justify: false)
  set table(stroke: if graduate { 1pt } else { 0.5pt }, align: center + horizon)

  // 表格独有配置
  show: captab-style.with(
    three-line-table: if graduate { true } else { false },
    supplement: if english-writing { "Table" } else { "表" },
    body-size: caption-format.size,
    cell-inset: (x: if graduate { 0.5em } else { 0.8em }, y: if graduate { 0.55em } else { 0.7em }),
    middle-rule: 1pt,
    caption-text: if graduate { (font: 字体.宋体混排) } else { (font: 字体.黑体) },
    caption-below: if graduate { auto } else { 10pt },
    table-below: if graduate { leading } else { 20pt },
    caption-above: if graduate { auto } else { 20pt },
    breakable: false,
    continued-caption: true,
    width: if graduate {100%} else {auto},
    number-title-spacing: if graduate { auto } else { 0.5em },
    extra-rule: if graduate {1pt} else {0.5pt}
  )
  // 图片独有配置
  show: capfig-style.with(
    supplement: if english-writing { "Figure" } else { "图" },
    show-subcaption: true,
    label-style: "（a）",
    subcaption-number-title-spacing: 0pt,
    caption-above: 0pt,
    figure-below: if graduate {auto} else {20pt},
    figure-above: if graduate {auto} else {20pt},
    subref-style: "full"
  )

  it
}

// 前置部分（摘要、目录）：罗马数字页码 + 标题不编号
#let frontmatter(body) = {
  set page(footer: page-footer("I"))
  set heading(numbering: none)
  counter(page).update(1)
  body
}
