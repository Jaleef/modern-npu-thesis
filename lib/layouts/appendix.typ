#import "@preview/cap-able:0.0.2": captab-style, capfig-style
#import "../utils/custom-numbering.typ": custom-numbering, show-equation-handler, figure-show-rule

// 附录布局
#let appendix(
  doctype: "bachelor",
  english-writing: false,
  leading: 0pt,
  it,
) = {
  let appendix-label = if english-writing {
    "Appendix "
  } else if doctype == "bachelor" {
    "附 录"
  } else {
    "附录"
  }

  set heading(numbering: custom-numbering.with(
    first-level: if doctype == "bachelor" {
      n => [#appendix-label]
    } else {
      n => [#appendix-label#numbering("A", n)]
    },
    depth: 4,
    "A.1 ",
  ))
  counter(heading).update(0)

  let is-graduate = doctype == "graduate"

  show: captab-style.with(numbering-format: "A-1", use-chapter: true)
  show: capfig-style.with(numbering-format: "A-1", use-chapter: true)
  show figure: figure-show-rule("A-1", is-graduate, leading)
  show math.equation.where(block: true): show-equation-handler("A-1", is-graduate)

  it
}
