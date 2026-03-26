#import "@preview/i-figured:0.2.4"
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/style.typ": 字体

// 后记，重置 heading 计数器
#let appendix(
  fonts: (:),
  numbering: (..nums) => context {
    let pos = nums.pos()
    let appendix-headings = query(
      selector(heading.where(level: 1)).after(selector(<appendix-start>)).before(selector(<appendix-end>)),
    )
    let multi-appendix = appendix-headings.len() > 1

    if pos.len() == 1 {
      let appendix-prefix = if multi-appendix {
        "附录" + numbering("A", ..pos)
      } else {
        "附　录"
      }
      [#appendix-prefix#h(1em)]
    } else if multi-appendix {
      numbering("A.1 ", ..pos)
    } else {
      numbering("1.1 ", ..pos)
    }
  },
  // figure 计数
  show-figure: i-figured.show-figure.with(numbering: "1-1"),
  // equation 计数
  show-equation: i-figured.show-equation.with(
    numbering: (..nums) => text(font: "Times New Roman")[#numbering("(1-1)", ..nums)],
  ),
  // 重置计数
  reset-counter: true,
  it,
) = {
  fonts = 字体 + fonts

  let appendix-heading-font = (
    (name: "Times New Roman", covers: "latin-in-cjk"),
    "SimHei",
    "Heiti SC",
    "STHeiti",
    "Noto Sans CJK SC",
    "Source Han Sans SC",
    "Source Han Sans",
  )

  set heading(numbering: numbering)
  if reset-counter {
    counter(heading).update(0)
  }

  set text(font: fonts.宋体)
  show heading: it => {
    set text(font: appendix-heading-font)
    it
  }
  show figure: show-figure
  // 设置 equation 的编号
  show math.equation.where(block: true): show-equation

  [#metadata(none) <appendix-start>#it#metadata(none) <appendix-end>]
}
