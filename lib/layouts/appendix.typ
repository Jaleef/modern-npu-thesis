#import "@preview/i-figured:0.2.4"
#import "../utils/style.typ": 字体
#import "../utils/custom-numbering.typ": custom-numbering

// 附录布局
#let appendix(
  twoside: false,
  doctype: "bachelor",
  english-writing: false,
  fonts: (:),
  // 重置计数
  reset-counter: true,
  it,
) = {
  fonts = 字体 + fonts

  pagebreak(weak: true, to: if twoside { "odd" })

  context {
    let appendix-headings = query(
      selector(heading.where(level: 1)).after(selector(<appendix-start>)).before(selector(<appendix-end>)),
    )
    let appendix-label = if english-writing {
      "Appendix "
    } else if doctype == "bachelor" {
      "附 录"
    } else {
      "附录"
    }
    let has-appendix = appendix-headings.len() > 0
    let appendix-prefix = if has-appendix {
      numbering("A", 1)
    } else {
      "A"
    }

    let appendix-numbering = if appendix-headings.len() > 1 {
      custom-numbering.with(
        first-level: n => if doctype == "bachelor" {
          [#appendix-label#numbering("A", n)]
        } else {
          [#appendix-label#numbering("A", n)]
        },
        depth: 4,
        "A.1 ",
      )
    } else {
      custom-numbering.with(
        first-level: n => if doctype == "bachelor" {
          [#appendix-label]
        } else {
          [#appendix-label#numbering("A", n)]
        },
        depth: 4,
        "1 ",
      )
    }

    set heading(numbering: appendix-numbering)
    if reset-counter {
      counter(heading).update(0)
    }

    show heading: i-figured.reset-counters
    show figure: i-figured.show-figure.with(numbering: appendix-prefix + "-1")
    set figure(supplement: if english-writing { [Figure] } else { [图] })
    show figure.where(kind: table): set figure(supplement: if english-writing { [Table] } else { [表] })
    set math.equation(supplement: if english-writing { [Equation] } else { [式] })
    show math.equation.where(block: true): if doctype == "bachelor" {
      i-figured.show-equation.with(
        numbering: (..nums) => {
          let eq-number = numbering(appendix-prefix + "-1", ..nums)
          text(font: fonts.宋体)[（#text(font: "Times New Roman")[#eq-number]）]
        },
      )
    } else {
      i-figured.show-equation.with(
        numbering: "(" + appendix-prefix + "-1)",
      )
    }

    [
      #metadata(none) <appendix-start>
      #it
      #metadata(none) <appendix-end>
    ]
  }
}
