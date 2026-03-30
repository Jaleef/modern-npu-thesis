#import "@preview/i-figured:0.2.4"
#import "../utils/style.typ": 字体
#import "../utils/custom-numbering.typ": custom-numbering

// 附录布局
#let appendix(
  twoside: false,
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
    let multi-appendix = appendix-headings.len() > 1

    let appendix-numbering = if multi-appendix {
      custom-numbering.with(
        first-level: n => [附录#numbering("A", n)#h(0.7em)],
        depth: 4,
        "A.1 ",
      )
    } else {
      custom-numbering.with(
        first-level: n => [附　录#h(0.7em)],
        depth: 4,
        "1.1 ",
      )
    }

    set heading(numbering: appendix-numbering)
    if reset-counter {
      counter(heading).update(0)
    }

    show heading: i-figured.reset-counters
    show figure: i-figured.show-figure.with(numbering: if multi-appendix { "A-1" } else { "1-1" })
    show math.equation.where(block: true): i-figured.show-equation.with(
      numbering: if multi-appendix { "(A-1)" } else { "(1-1)" },
    )

    [
      #metadata(none) <appendix-start>
      #it
      #metadata(none) <appendix-end>
      #if twoside {
        pagebreak(weak: true, to: "even")
      }
    ]
  }
}
