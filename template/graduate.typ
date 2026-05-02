#import "/template.typ": (
  algorithm, algorithm-ref, blind-review, capfig, capsubfig, captab, equation-note, indent, multicite, nwpu-thesis,
)

#show: nwpu-thesis.with(
  doctype: "graduate", // "graduate"
  degree: "master", // "master" | "doctor"，研究生学位级别
  track: "professional", // "academic" | "professional"，培养类型
  anonymous: false, // 是否开启盲审模式
  english-writing: false, // 是否用英文写作（国际研究生论文）
  colored-cover: true, // 是否启用彩色封面
  title: ("基于 Typst 的", "西北工业大学论文模板"),
  title-en: "This is a Northwestern Polytechnical University thesis template based on Typst",
  student-id: "2023123456",
  class-no: "TP311.1",
  author: "航小天",
  author-en: "Xiaotian Hang",
  department: "计算机学院",
  major: "计算机科学与技术",
  // major-en: "Computer Science and Technology", // 一般情况下模板会自动填充英文专业名称，如果发现不正确或未自动填充可以在这里手动指定，并提出 issue 反馈
  supervisor: ("张三", "教授"),
  supervisor-en: "San Zhang",
  submit-date: (year: 2026, month: 3),
  reviewers: (
    (name: "xxx", title: "教授", unit: "西北工业大学"),
    blind-review,
  ),
  defence-committee: (
    date: datetime(year: 2026, month: 3, day: 9),
    chairman: (name: "赵某某", title: "教授", unit: "西北工业大学"),
    members: (
      (name: "周某某", title: "教授", unit: "西北工业大学"),
      (name: "吴某某", title: "副教授", unit: "西北工业大学"),
    ),
    secretary: (name: "郑某某", title: "讲师", unit: "西北工业大学"),
  ),
  abstract: [
    中文摘要一般应说明研究工作目的、实验方法、结果和最终结论等，而重点是结果和结论。摘要中不用图、表、化学结构式、非公知公用的符号和术语。
    
    内容一般包括：从事这项研究工作的目的和意义；完成的工作（作者独立进行的研究工作及相应结果的概括性叙述）；获得的主要结论（这是摘要的中心内容）。
  ],
  keywords: ("关键词一", "关键词二", "关键词三", "关键词四"),
  funding: "本研究得到某某基金（编号：   ）资助。",
  abstract-en: [
    English abstract content. The abstract should generally explain the purpose, experimental methods, results, and final conclusions of the research, with emphasis on the results and conclusions.
  ],
  keywords-en: ("Keyword1", "Keyword2", "Keyword3", "Keyword4"),
  funding-en: "The present work is supported by the XXX（Project No.xxx）",
  appendix: [
    == Test
    附录是学位论文主体的补充，并不是必需的。
    
    $ phi.alt := (1 + sqrt(5)) / 2 $ <rat>
    
    =
    附录编号依次编为附录A、附录B。附录标题各占一行，按一级标题编排。每一个附录一般应另起一页编排，如果有多个较短的附录，也可接排。
    
    $ phi.alt := (1 + sqrt(5)) / 2 $ <ra>
  ],
  acknowledgement: [
    致谢是作者对该文章的形成作过贡献的组织或个人予以感谢的文字记载，语言要诚恳、恰当、简短。致谢内容可以包括但不限于：国家科学基金、资助研究工作的奖学金基金、合同单位、资助或支持的企业、组织或个人；协助完成研究工作和提供便利条件的组织或个人；在研究工作中提出建议和提供帮助的人；给予转载和引用权的资料、图片、文献、研究和调查的所有者；其他应感谢的组织和个人。
  ],
  academic-achievements: [
    不同类型的成果列表书写格式与参考文献相同。对于学术论文，如已发表的被EI或SCI收录，应标明收录号；SCI论文一般应标注发表当年的影响因子；对已录用但尚未发表的学术论文，请注明是否EI或SCI刊源。
  ],
  scan-declaration: image("figures/声明.pdf"),
)

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

引用@timing-tlt，以及@test。使用 `captab()` 创建三线表时，引用直接使用标签名；`capfig()` 同样直接使用标签名。

#captab(
  caption: [三线表],
  label: <timing-tlt>,
)[
  | t   | 1    | 2    | 3    |
  | --- | ---- | ---- | ---- |
  | y   | 0.3s | 0.4s | 0.8s |
]

#captab(
  caption: [复杂三线表示例：聚合物基复合材料的性能（captab 渲染）],
  label: <composite-performance>,
  cols: (1.25fr, 1fr, 1fr, 1fr, 1fr),
  hlines: (
    (row: 2, stroke: 1pt),
  ),
)[
  | 材料           | 碳/环氧 | <    | 玻璃/环氧 | <    |
  | ^              | 纵向    | 横向 | 纵向      | 横向 |
  | 模量，GPa      | 181     | 10.3 | 38.6      | 8.3  |
  | 压缩强度，MPa  | 1500    | 246  | 610       | 118  |
  | 拉伸强度，MPa  | 1500    | 40   | 1062      | 31   |
]

#capfig(
  image("figures/博士论文封面.jpg", width: 45%),
  caption: [图片测试],
  label: <test>,
)

图片之间的文字

#capsubfig(
  (
    (content: image("figures/博士论文封面.jpg", width: 60%), subcaption: [第一个子图说明]),
    (content: image("figures/博士论文封底.jpg", width: 60%), subcaption: [第二个子图说明]),
  ),
  columns: 2,
  caption: [总图标题],
  label: <fig-main>,
)

#capsubfig(
  (
    (content: image("figures/专硕论文封面.jpg", width: 50%), subcaption: [第一个子图说明]),
    (content: image("figures/专硕论文封底.jpg", width: 50%), subcaption: [第二个子图说明]),
    (content: image("figures/学硕论文封面.jpg", width: 50%), subcaption: [第三个子图说明]),
    (content: image("figures/学硕论文封底.jpg", width: 50%), subcaption: [第四个子图说明]),
  ),
  columns: 2,
  caption: [总图标题],
  label: <fig-2x2>,
)

== 数学公式

可以像 Markdown 一样写行内公式 $x + y$，以及带编号的行间公式：

$ phi.alt := (1 + sqrt(5)) / 2 $ <ratio>

引用数学公式需要加上 `eqt:` 前缀，则由@eqt:ratio，我们有：

$ F_n = floor(1 / sqrt(5) phi.alt^n) $

我们也可以通过 `<->` 标签来标识该行间公式不需要编号

$ y = integral_1^2 x^2 dif x $ <->

而后续数学公式仍然能正常编号。

$ F_n = floor(1 / sqrt(5) phi.alt^n) $

如果需要在公式下方给出变量含义说明，可以使用统一的辅助宏：

$ E = m c^2 $
#equation-note[$E$ 为能量，$m$ 为质量，$c$ 为光速。]

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

可以像这样引用参考文献@周融2003，引用两个的文献 #multicite("图书馆", "李大伦1998")，引用三个以上的文献 #multicite("伍蠡甫", "张筑生", "冯西桥1998", "姜锡洲", "gbt16159-1996", "科学技术期刊管理办法", "中国大学学报论文文摘")。

= 研究方法

== 方法概述

方法概述内容。

#capfig(
  image("figures/博士论文封面.jpg", width: 45%),
  caption: [图片测试],
  label: <test1>,
)


== 实验设计

实验设计内容。
