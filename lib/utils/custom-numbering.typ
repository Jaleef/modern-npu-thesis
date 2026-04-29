#import "@preview/i-figured:0.2.4"
#import "style.typ": 字号

// 一个简单的自定义 Numbering
// 用法也简单，可以特殊设置一级等标题的样式，以及一个缺省值
#let custom-numbering(base: 1, depth: 5, first-level: auto, second-level: auto, third-level: auto, format, ..args) = {
  if args.pos().len() > depth {
    return
  }
  if first-level != auto and args.pos().len() == 1 {
      if first-level != "" {
          if type(first-level) == function {
              first-level(..args.pos())
          } else {
              numbering(first-level, ..args)
          }
      }
      return
  }
  if second-level != auto and args.pos().len() == 2 {
      if second-level != "" {
          numbering(second-level, ..args)
      }
      return
  }
  if third-level != auto and args.pos().len() == 3 {
      if third-level != "" {
          numbering(third-level, ..args)
      }
      return
  }
  // default
  if args.pos().len() >= base {
      numbering(format, ..(args.pos().slice(base - 1)))
      return
  }
}

// 公式编号处理：研究生用半角括号 (1-1)，本科用全角括号 （1-1）
#let show-equation-handler(prefix, is-graduate) = {
  if is-graduate {
    i-figured.show-equation.with(
      numbering: (..nums) => numbering("(" + prefix + ")", ..nums),
    )
  } else {
    i-figured.show-equation.with(
      numbering: (..nums) => [（#numbering(prefix, ..nums)）],
    )
  }
}

// figure 编号与排版处理
// 图片和研究生表格由 cap-able 处理，其余由 i-figured 编号
// 本科额外添加上下间距
#let figure-show-rule(prefix, is-graduate, leading) = it => {
  let bachelor-figure-gap = 字号.小四 + leading
  let handler = i-figured.show-figure.with(numbering: prefix)
  if it.kind == image or (is-graduate and it.kind == table) {
    it
  } else {
    let rendered = handler(it)
    if is-graduate {
      rendered
    } else {
      block(above: bachelor-figure-gap, below: bachelor-figure-gap)[#rendered]
    }
  }
}
