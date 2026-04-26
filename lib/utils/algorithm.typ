#import "../utils/style.typ": 字号
#import "@preview/lovelace:0.3.1": pseudocode as _pseudocode, indent, no-number, pseudocode-list

#let algorithm-figure = figure.where(kind: "algorithm")
#let english-writing-state = state("nwpu-english-writing", false)

#let localized-term(chinese, english) = context {
  if english-writing-state.get() {
    [#english]
  } else {
    [#chinese]
  }
}

#let localized-field(chinese, english, value) = context {
  if english-writing-state.get() {
    [*#english:* #value]
  } else {
    [*#chinese：* #value]
  }
}

#let with-english-writing(enabled, it) = {
  english-writing-state.update(enabled)
  it
}

#let algorithm-label(number, loc) = context {
  let heading-number = counter(heading).at(loc).first()
  let is-appendix = query(selector(<appendix-start>).before(loc)).len() > query(selector(<appendix-end>).before(loc)).len()
  let appendix-count = query(
    selector(heading.where(level: 1)).after(selector(<appendix-start>)).before(selector(<appendix-end>)),
  ).len()
  if is-appendix {
    let appendix-prefix = if appendix-count > 1 {
      numbering("A", heading-number)
    } else {
      numbering("A", 1)
    }
    [#appendix-prefix-#numbering("1", number)]
  } else {
    numbering("1-1", heading-number, number)
  }
}

#let algorithm-numbering(number) = context algorithm-label(number, here())

#let algorithm-ref(label) = context {
  let element = query(label).first()
  link(
    element.location(),
    [#localized-term("算法", "Algorithm") #algorithm-label(counter(algorithm-figure).at(element.location()).first(), element.location())],
  )
}

#let algorithm(title: none, input: none, output: none, ..body) = {
  let preamble = ()
  if input != none {
    preamble.push(no-number[#localized-field("输入", "Input", input)])
  }
  if output != none {
    preamble.push(no-number[#localized-field("输出", "Output", output)])
  }

  figure(
    kind: "algorithm",
    supplement: localized-term("算法", "Algorithm"),
    numbering: algorithm-numbering,
    outlined: false,
    caption: none,
    {
      show grid: it => {
        let cols = it.columns
        if type(cols) == array and cols.all(c => c == auto) and cols.len() > 0 {
          let f = it.fields()
          grid(
            columns: cols.slice(0, cols.len() - 1) + (1fr,),
            column-gutter: f.at("column-gutter", default: 0pt),
            row-gutter: f.at("row-gutter", default: 0pt),
            ..f.at("children", default: ()),
          )
        } else {
          it
        }
      }
      _pseudocode(
        booktabs: true,
        booktabs-stroke: 1pt + black,
        line-numbering: "1",
        stroke: none,
        title: context {
          let num = algorithm-numbering(counter(algorithm-figure).get().first())
          [*#localized-term("算法", "Algorithm") #num* #title]
        },
        ..preamble,
        ..body,
      )
    },
  )
}
