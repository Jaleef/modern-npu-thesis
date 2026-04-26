#import "/template.typ": algorithm, algorithm-ref, bachelor-thesis-config, equation-note, indent, nwpu-thesis, subfigure-caption
#import "@preview/gb7714-bilingual:0.2.3": multicite

#let thesis-config = bachelor-thesis-config(
  title: ("基于 Typst 的西工大论文模板"),
  author: "航小天",
  major: "计算机科学与技术",
  supervisor: ("张三", "教授"),
  submit-date: (year: 2026, month: 3),
  abstract: [
    听觉虚拟又可称为可听化，是近年来随着声学仿真技术的发展而出现的新概念，即通过对包含单个（或多个）声源的声场进行物理或数学建模，以达到模拟空间听音效果的目的。若考虑双耳效应，则可称为双耳听觉虚拟（Binaural Modeling）。

    ……
  ],
  keywords: ("听觉虚拟", "HRTF", "神经网络"),
  abstract-en: [
    Virtual auditory technology is also called auralization. It is brought forward as a new concept with the development of acoustic simulation techniques in recent years and can be implemented by establishing the physical or mathematical models of a sound field to achieve sound effects simulation. If we consider the binaural effect, it can be called binaural virtual auditory.

    ……..
  ],
  keywords-en: ("virtual auditory", "HRTF", "neural network"),
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

      table.hline(y: 0, stroke: 0.5pt),
      table.header([t], [1], [2], [3]),
      table.hline(y: 1, stroke: 0.5pt),
      [y], [0.3s], [0.4s], [0.8s],
      table.hline(y: 2, stroke: 0.5pt),
    ),
    caption: [表],
  ) <timing-tlt>

  #figure(
    table(
      columns: (1.25fr, 1fr, 1fr, 1fr, 1fr),

      table.hline(y: 0, stroke: 0.5pt),
      table.cell(rowspan: 2)[材料],
      table.cell(colspan: 2)[碳/环氧],
      table.cell(colspan: 2)[玻璃/环氧],
      table.hline(y: 1, start: 1, stroke: 0.5pt),
      [纵向], [横向], [纵向], [横向],
      table.hline(y: 2, stroke: 0.5pt),
      [模量，GPa], [181], [10.3], [38.6], [8.3],
      [压缩强度，MPa], [1500], [246], [610], [118],
      [拉伸强度，MPa], [1500], [40], [1062], [31],
      table.hline(y: 5, stroke: 0.5pt),
    ),
    caption: [复杂表示例：聚合物基复合材料的性能],
  ) <composite-performance>

  #figure(
    image("figures/博士论文封面.jpg", width: 45%),
    caption: [图片测试],
  ) <test>

  图片之间的文字

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      align(center)[
        #image("figures/博士论文封面.jpg", width: 60%)
        #subfigure-caption[(a) 第一个子图说明]
      ],
      align(center)[
        #image("figures/博士论文封底.jpg", width: 60%)
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
    [left := 0],
    [right := len(A) - 1],
    [*while* left <= right *do*],
    indent(
      [mid := floor((left + right) / 2)],
      [*if* A.at(mid) == target *then*],
      indent([return mid]),
      [*else if* A.at(mid) < target *then*],
      indent([left := mid + 1]),
      [*else*],
      indent([right := mid - 1]),
      [*end*],
    ),
    [return -1],
  ) <alg:binary-search>

  == 参考文献

  可以像这样引用参考文献@周融2003，引用两个的文献 #multicite("伍蠡甫", "图书馆")，引用三个以上的文献 #multicite("张筑生", "gbt16159-1996", "冯西桥1998", "姜锡洲", "中国大学学报论文文摘")。
]

#show: nwpu-thesis.with(..thesis-config)
#thesis-body
