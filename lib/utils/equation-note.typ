#import "../deps.typ": zh
#import "../utils/algorithm.typ": english-writing-state

#let equation-note(body) = context {
  block(width: 100%)[
    #set par(first-line-indent: 0pt, justify: false)
    #set text(zh(5))
    #if english-writing-state.get() {
      [where ]
    } else {
      [式中，]
    }
    #body
  ]
}
