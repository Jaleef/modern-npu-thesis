#let 字体 = (
  宋体混排: (
    (name: "Times New Roman", covers: "latin-in-cjk"),
    "SimSun",
  ),
  黑体: ("SimHei",),
  黑体混排: (
    (name: "Times New Roman", covers: "latin-in-cjk"),
    "SimHei",
  ),
)

#let chinese-chapter-number(n) = {
  ("一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(n - 1)
}
