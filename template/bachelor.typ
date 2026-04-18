#import "/template.typ": algorithm, algorithm-ref, bachelor-thesis-config, equation-note, nwpu-thesis, subfigure-caption

#let thesis-config = bachelor-thesis-config(
  title: ("基于 Typst 的西工大论文模板"),
  author: "航小天",
  major: "计算机科学与技术",
  supervisor: ("张三", "教授"),
  submit-date: (year: 2026, month: 3),
  bibliography: bibliography.with("ref.bib"),
  abstract: [
    中文摘要内容。
  ],
  keywords: ("关键词一", "关键词二", "关键词三", "关键词四"),
  abstract-en: [
    English abstract content.
  ],
  keywords-en: ("Keyword1", "Keyword2", "Keyword3", "Keyword4"),
  appendix: [
    附录内容……
  ],
  acknowledgement: [
    致谢内容……
  ],
  design_summary: [
    小结内容……
  ],
)

#let thesis-body = [

  = 绪论

  XXX

  == 研究背景

  XXX

  === 研究意义

  研究意义内容。

  === 研究现状

  研究现状内容。

  == 研究内容

  研究内容概述。

  == 图表测试

  引用@tbl:timing-tlt，以及@fig:test。引用图表时，表格和图片分别需要加上 `tbl:`和`fig:` 前缀才能正常显示编号。

  #figure(
    table(
      columns: (1fr, 1fr, 1fr, 1fr),
      stroke: none,
      inset: (x: 0.3em, y: 0.4em),
      align: center + horizon,

      table.hline(y: 0, stroke: 1.5pt),
      table.header([t], [1], [2], [3]),
      table.hline(y: 1, stroke: 0.5pt),
      [y], [0.3s], [0.4s], [0.8s],
      table.hline(y: 2, stroke: 1.5pt),
    ),
    caption: [三线表],
  ) <timing-tlt>

  #figure(
    table(
      columns: (1.25fr, 1fr, 1fr, 1fr, 1fr),
      stroke: none,
      inset: (x: 0.3em, y: 0.4em),
      align: center + horizon,

      table.hline(y: 0, stroke: 1.5pt),
      table.cell(rowspan: 2)[材料],
      table.cell(colspan: 2)[碳/环氧],
      table.cell(colspan: 2)[玻璃/环氧],
      table.hline(y: 1, start: 1, stroke: 0.5pt),
      [纵向], [横向], [纵向], [横向],
      table.hline(y: 2, stroke: 0.5pt),
      [模量，GPa], [181], [10.3], [38.6], [8.3],
      [压缩强度，MPa], [1500], [246], [610], [118],
      [拉伸强度，MPa], [1500], [40], [1062], [31],
      table.hline(y: 5, stroke: 1.5pt),
    ),
    caption: [复杂三线表示例：聚合物基复合材料的性能],
  ) <composite-performance>

  #figure(
    image("images/博士论文封面.jpg", width: 45%),
    caption: [图片测试],
  ) <test>

  图片之间的文字

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      align(center)[
        #image("images/博士论文封面.jpg", width: 60%)
        #subfigure-caption[(a) 第一个子图说明]
      ],
      align(center)[
        #image("images/博士论文封底.jpg", width: 60%)
        #subfigure-caption[(b) 第二个子图说明]
      ],
    ),
    caption: [总图标题],
  ) <fig-main>

  == 数学公式

  可以像 Markdown 一样写行内公式 $x + y$，以及带编号的行间公式：

  $ phi.alt := (1 + sqrt(5)) / 2 $ <ratio>

  引用数学公式需要加上 `eqt:` 前缀，则由@eqt:ratio，我们有：

  $ F_n = floor(1 / sqrt(5) phi.alt^n) $

  我们也可以通过 `<->` 标签来标识该行间公式不需要编号

  $ y = integral_1^2 x^2 dif x $ <->

  而后续数学公式仍然能正常编号。

  $ F_n = floor(1 / sqrt(5) phi.alt^n) $

  == 算法示例

  下面给出采用单独算法编号的三线表风格算法示例，见#algorithm-ref(<alg:binary-search>)。

  #algorithm(
    title: [二分查找算法],
    input: [有序数组 $A$，目标值 target。],
    output: [目标值下标，不存在则返回 -1。],
    steps: (
      [left := 0],
      [right := len(A) - 1],
      [while left <= right do],
      [  mid := floor((left + right) / 2)],
      [  if A.at(mid) == target],
      [    return mid],
      [  else if A.at(mid) < target],
      [    left := mid + 1],
      [  else],
      [    right := mid - 1],
      [return -1],
    ),
  ) <alg:binary-search>

  == 参考文献

  可以像这样引用参考文献@蒋有绪1998，引用两个以上的文献时，文献之间用逗号分隔，如@WHO1970 @张志祥1998，引用三个以上的文献 @河北绿洲2001 @李炳穆2000 @丁文祥2000。
]

#show: nwpu-thesis.with(..thesis-config)
#thesis-body
