#import "../utils/style.typ": 字体, 字号
#import "../utils/header.typ": header-render
#import "../layouts/preface.typ": (
  preface-heading-style, preface-heading-above, preface-heading-below,
)

// 目录生成页面
#let outline-page(
  // documentclass 传入参数
  twoside: false,
  doctype: "bachelor",
  fonts: (:),
  // 其他参数
  depth: 4,
  title: auto,
  outlined: false,
  title-vspace: 0pt,
  title-text-args: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  // 引用页数的字体，这里用于显示 Times New Roman
  reference-font: auto,
  reference-size: auto,
  // 字体与字号
  font: auto,
  size: auto,
  indent: (0pt, 20pt, 20pt),
  weight: auto,
  // 默认引导符
  fill: auto,
  gap: .3em,
  // 行间距
  leading: auto,
  spacing: 0pt,
  ..args,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts

  // 研究生和本科生使用不同的默认格式
  let is-graduate = doctype == "master" or doctype == "doctor"
  let chinese_chapter_number(n) = {
    let digits = ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九")
    if n <= 10 {
      if n == 10 { "十" } else { digits.at(n) }
    } else if n < 20 {
      "十" + digits.at(calc.rem(n, 10))
    } else if calc.rem(n, 10) == 0 {
      digits.at(calc.floor(n / 10)) + "十"
    } else {
      digits.at(calc.floor(n / 10)) + "十" + digits.at(calc.rem(n, 10))
    }
  }

  if not is-graduate and depth == 4 {
    depth = 2
  }

  // 标题默认值
  if title == auto {
    title = if is-graduate { "目　录" } else { "目 录" }
  }

  if title-text-args == auto {
    title-text-args = if is-graduate {
      (font: fonts.黑体, size: 字号.三号)
    } else {
      (font: fonts.黑体, size: 字号.三号, weight: "bold")
    }
  }
  if title-leading == auto {
    title-leading = if is-graduate { 0.9em } else { leading }
  }
  if title-above == auto {
    title-above = if is-graduate { preface-heading-above } else { 0pt }
  }
  if title-below == auto {
    title-below = if is-graduate { preface-heading-below } else { 0pt }
  }
  // 引用页数的字体，这里用于显示 Times New Roman
  if reference-font == auto {
    reference-font = fonts.宋体
  }
  if reference-size == auto {
    reference-size = 字号.小四
  }
  // 字体与字号
  if font == auto {
    font = if is-graduate {
      (fonts.宋体, fonts.宋体)
    } else {
      (fonts.宋体, fonts.宋体)
    }
  }
  if size == auto {
    size = if is-graduate {
      (字号.小四, 字号.小四)
    } else {
      (字号.四号, 字号.小四)
    }
  }
  if weight == auto {
    weight = if is-graduate {
      ("regular", "regular", "regular")
    } else {
      ("bold", "regular", "regular")
    }
  }
  if fill == auto {
    fill = if is-graduate {
      (repeat([.], gap: 0.15em),)
    } else {
      (repeat([#move(dy: -0.1em, text(size: 0.4em)[·])], gap: -0.1em),)
    }
  }
  // 行间距
  if leading == auto {
    leading = 14pt
  }

  // 2.  正式渲染
  pagebreak(weak: true, to: if is-graduate { "odd" })

  // 页眉


  // 默认显示的字体
  set text(font: reference-font, size: reference-size)

  [
    // 目录标题：字体由 title-text-args 控制，间距使用统一配置
    #show heading.where(level: 1, numbering: none): it => {
      set text(..title-text-args)
      preface-heading-style(
        it,
        fonts,
        leading: title-leading,
        below: title-below,
      )
    }
    #v(title-above)
    #heading(level: 1, outlined: outlined, title)

    #v(title-vspace)

    // 目录样式
    #set par(leading: leading, spacing: spacing)
    #set outline(indent: level => indent.slice(0, calc.min(level + 1, indent.len())).sum())
    #show outline.entry: entry => {
      let in-mainmatter-or-later = query(
        selector(<__nwpu_mainmatter_start__>).before(entry.element.location()),
      ).len() > 0
      let entry-page-number = counter(page).at(entry.element.location()).first()
      let entry-page-display = if is-graduate and not in-mainmatter-or-later {
        text(font: "Times New Roman")[#numbering("I", entry-page-number)]
      } else {
        text(font: reference-font, size: reference-size)[#numbering("1", entry-page-number)]
      }
      let is-appendix-entry = (
        query(selector(<appendix-start>).before(entry.element.location())).len()
        > query(selector(<appendix-end>).before(entry.element.location())).len()
      )
      let prefix = if not is-graduate and entry.level == 1 and entry.prefix() not in (none, []) and not is-appendix-entry {
        let nums = counter(heading).at(entry.element.location())
        [第#chinese_chapter_number(nums.first())章 ]
      } else {
        entry.prefix()
      }
      let prefix-gap = if not is-graduate and is-appendix-entry and entry.level == 1 {
        0pt
      } else {
        gap
      }
      // 研究生使用固定行间距，不额外添加 above/below
      let entry-content = link(
        entry.element.location(),
        entry.indented(
          none,
          {
            text(
              font: font.at(entry.level - 1, default: font.last()),
              size: size.at(entry.level - 1, default: size.last()),
              weight: weight.at(entry.level - 1, default: weight.last()),
              {
                if prefix not in (none, []) {
                  prefix
                  h(prefix-gap)
                }
                entry.body()
              },
            )
            box(width: 1fr, inset: (x: .25em), fill.at(entry.level - 1, default: fill.last()))
            entry-page-display
          },
          gap: 0pt,
        ),
      )
      if is-graduate {
        // 研究生：固定行间距，每条目占一行
        entry-content
      } else {
        // 本科生：各级目录项使用统一段间距
        block(
          above: if entry.level == 1 { 1.5em } else { 1em },
          below: 0.1em,
          entry-content,
        )
      }
    }

    // 显示目录
    #outline(title: none, depth: depth)
  ]

  // 调试信息
  // context { text("目录结束，当前页码: " + str(here().page()) + ", is-graduate: " + str(is-graduate) + ", twoside: " + str(twoside)) }
}
