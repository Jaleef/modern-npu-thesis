#import "@preview/i-figured:0.2.4"
#import "@preview/cap-able:0.0.2": captab-style, capfig-style
#import "../utils/style.typ": 字体, 字号
#import "../utils/custom-numbering.typ": custom-numbering, show-equation-handler, figure-show-rule
#import "../utils/custom-heading.typ": active-heading, heading-display
#import "../utils/unpairs.typ": unpairs
#import "../utils/chinese-number.typ": chinese-chapter-number
#import "../utils/header.typ": bachelor-header-render, graduate-header-title, header-render
#import "../format.typ": body-format, heading-format, caption-format, header-format, table-format

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  doctype: "bachelor",
  english-writing: false,
  // 正文段落格式
  leading: body-format.bachelor.leading,
  spacing: body-format.bachelor.spacing,
  justify: true,
  first-line-indent: body-format.bachelor.first-line-indent,
  heading-numbering: none,
  // 标题字体与字号
  heading-font: (字体.黑体,),
  heading-size: (字号.三号, 字号.四号, 字号.小四),
  heading-weight: ("regular", "regular", "regular"),
  heading_leading: heading-format.bachelor.leading,
  heading-above: heading-format.bachelor.above,
  heading-below: heading-format.bachelor.below,
  // 页眉
  stroke-width: 0.5pt,
  reset-footnote: true,
  graduate_headsep: header-format.graduate.headsep,
  graduate_headrule_offset: header-format.graduate.headrule-offset,
  graduate_headrule_thick: header-format.graduate.headrule-thick,
  graduate_headrule_thin: header-format.graduate.headrule-thin,
  graduate_headrule_gap: header-format.graduate.headrule-gap,
  // caption 的 separator
  separator: caption-format.separator,
  // caption 样式（宋体五号不加粗）
  caption-style: it => it,
  caption-size: caption-format.size,
  // figure 计数
  show-figure: i-figured.show-figure.with(numbering: "1-1"),
  ..args,
  it,
) = {
  let is-graduate = doctype == "graduate"
  let table-kinds = (table, "i-figured-table")
  let equation-handler = show-equation-handler("1-1", is-graduate)

  // 重置页码为阿拉伯数字从1开始（由调用方在正文开始位置处理 pagebreak 和 counter reset）
  set page(
    footer: context align(center)[
      #set text(size: 字号.小五)
      #counter(page).display("1")
    ],
  )

  // 2.  处理 heading- 开头的其他参数
  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 3.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 4.  设置基本样式
  // 4.1 文本和段落样式
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: spacing,
  )
  // 4.2 设置 figure 的编号
  show heading: i-figured.reset-counters
  show figure: figure-show-rule("1-1", is-graduate, leading)
  set figure(supplement: if english-writing { [Figure] } else { [图] })
  show figure.where(kind: table): set figure(supplement: if english-writing { [Table] } else { [表] })
  show figure.where(kind: "i-figured-table"): set figure(supplement: if english-writing { [Table] } else { [表] })
  // 4.4 设置 equation 的编号和假段落首行缩进
  set math.equation(supplement: if english-writing { [Equation] } else { [式] })
  show math.equation.where(block: true): equation-handler
  // 4.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)
  show figure.where(
    kind: "i-figured-table",
  ): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: it => {
    if not is-graduate and it.kind in table-kinds {
      text(font: 字体.黑体, size: 字号.五号)[
        #it.supplement
        #h(0.08em)
        #context it.counter.display(it.numbering)
        #h(0.28em)
        #it.body
      ]
    } else {
      text(size: 字号.五号)[#it]
    }
  }
  // 表格内容使用五号字体
  show table: set text(size: 字号.五号)
  set table(
    stroke: if is-graduate { none } else { 0.5pt },
    inset: (x: 0.3em, y: if is-graduate { 0.5em } else { 0.7em }),
    align: center + horizon,
  )

  // 5.  处理标题
  // 5.1 设置标题的 Numbering
  set heading(numbering: heading-numbering)
  // 5.2 设置字体、字号、换页及段后段后间距
  show heading: it => {
    if it.level == 1 {
      counter(figure.where(kind: "algorithm")).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: "i-figured-table")).update(0)
    }

    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set par(leading: array-at(heading_leading, it.level), spacing: 0pt)

    // 一级标题统一换页
    if it.level == 1 {
      pagebreak(weak: true, to: if twoside { "odd" })
      v(array-at(heading-above, it.level))
    }

    let current-block-above = if it.level == 1 { 0pt } else { array-at(heading-above, it.level) }
    let current-block-below = array-at(heading-below, it.level)

    if it.level == 1 {
      set align(center)
      set block(above: current-block-above, below: current-block-below)
      it
    } else {
      set block(above: current-block-above, below: current-block-below)
      it
    }
  }

  // 6.  处理页眉
  set page(header: context {
    // 重置 footnote 计数器
    if reset-footnote {
      counter(footnote).update(0)
    }
    let loc = here()
    // 页眉内容
    let header-content = if twoside and calc.rem(loc.page(), 2) == 0 and is-graduate {
      // 偶数页：显示论文标题
      graduate-header-title(doctype)
    } else {
      // 奇数页或单面打印：显示当前章标题
      heading-display(active-heading(level: 1, prev: false))
    }
    // 使用统一的页眉格式
    if is-graduate {
      header-render(
        header-content,
        graduate_headsep: graduate_headsep,
        graduate_headrule_offset: graduate_headrule_offset,
        graduate_headrule_thick: graduate_headrule_thick,
        graduate_headrule_thin: graduate_headrule_thin,
        graduate_headrule_gap: graduate_headrule_gap,
      )
    } else {
      bachelor-header-render(offset: header-format.bachelor.offset)
    }
  })

  // 研究生使用 cap-able 配置三线表全局样式
  if is-graduate {
    show: captab-style.with(
      numbering-format: "1-1",
      use-chapter: true,
      supplement: "表",
      caption-size: caption-size,
      caption-weight: "regular",
      body-size: 字号.五号,
      cell-inset: (x: 0.3em, y: 0.5em),
      enable-english-caption: false,
      pre-supplement-number-spacing: 0em,
      number-title-spacing: [\u{3000}],
      middle-rule: (paint: black, thickness: 1pt),
    )
  }

  // 使用 cap-able 配置图片全局样式
  show: capfig-style.with(
    numbering-format: "1-1",
    use-chapter: true,
    supplement: "图",
    caption-size: caption-size,
    caption-weight: "regular",
    enable-english-caption: false,
    pre-supplement-number-spacing: 0em,
    number-title-spacing: [\u{3000}],
    show-subcaption: true,
    show-subcaption-label: true,
    label-style: "(a)",
    gutter: 1em,
  )

  it
}

// 前置部分（摘要、目录）：罗马数字页码 + 标题不编号
#let frontmatter(body) = {
  set page(footer: context align(center)[
    #set text(size: 字号.小五)
    #counter(page).display("I")
  ])
  set heading(numbering: none)
  counter(page).update(1)
  body
}
