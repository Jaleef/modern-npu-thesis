#import "deps.typ": (
  Assign, Break, Comment, Else, ElseIf, For, Function, If, IfElseChain, Line, LineBreak, Procedure, Return, Terminate,
  While, capfig, capfig-style, capsubfig, captab, captab-style, init-gb7714, multicite, zh,
)
#import "layouts/doc.typ": doc
#import "layouts/floats.typ": algorithm, equation-note
#import "layouts/mainmatter.typ": frontmatter, mainmatter
#import "pages/appendix.typ": appendix as appendix-layout
#import "pages/bachelor-cover.typ": bachelor-cover
#import "pages/graduate-cover.typ": master-cover
#import "pages/abstract.typ": abstract-page
#import "pages/outline.typ": outline-page
#import "pages/backmatter-page.typ": backmatter-page
#import "pages/references.typ": bilingual-bibliography
#import "utils.typ": blind-review, distribute, page-title

#let default-bibliography(graduate) = {
  if not graduate {
    "../template/bib/bachelor.bib"
  } else {
    "../template/bib/graduate.bib"
  }
}

#let code-frame(body) = block(
  width: 100%,
  stroke: 0.6pt + luma(180),
  radius: 4pt,
  fill: luma(248),
  inset: 10pt,
)[#body]

#let nwpu-thesis(
  graduate: false,
  degree: "master",
  track: "academic",
  anonymous: false,
  english-writing: false,
  colored-cover: false,
  info: (:),
  abstract: (:),
  abstract-en: (:),
  acknowledgement: none,
  academic-achievements: none,
  appendix: none,
  scan-declaration: none,
  design-summary: none,
  body,
) = {
  let bibliography = default-bibliography(graduate)

  // 1. 文稿设置
  show: doc.with(graduate: graduate)

  // 2. 封面
  if graduate {
    master-cover(
      degree: degree,
      track: track,
      colored-cover: colored-cover,
      anonymous: anonymous,
      info: info,
    )
  } else {
    bachelor-cover(
      anonymous: anonymous,
      info: info,
    )
  }

  show: init-gb7714.with(
    read(bibliography),
    style: "numeric",
    version: "2025",
    zh-period: if not graduate { "．" },
    zh-colon: if not graduate { "： " },
    zh-comma: if not graduate { "，" },
    en-family-titlecase: not graduate,
  )

  // 3. mainmatter 包裹所有后续内容（前置 + 正文 + 后置）
  show: mainmatter.with(
    graduate: graduate,
    degree: degree,
    english-writing: english-writing,
  )

  show raw.where(block: true): it => code-frame(it)

  // 4. 前置部分（摘要、目录）
  frontmatter[
    #abstract-page(
      abstract: abstract,
      keyword-label: "关键词",
      keyword-sep: if graduate { "；" } else { "，" },
      keyword-indent: graduate,
      outline-title: page-title("abstract", graduate: graduate),
      outlined: graduate,
    )
    #abstract-page(
      abstract: abstract-en,
      keyword-label: if graduate { "Key words" } else { "KEY WORDS" },
      keyword-weight: "bold",
      keyword-sep: if graduate { "; " } else { ", " },
      keyword-indent: false,
      outline-title: "ABSTRACT",
      title: if graduate { [*Abstract*] },
      outlined: graduate,
    )

    #{
      let outline-title = page-title("outline", graduate: graduate, english-writing: english-writing)
      outline-page(
        title: if graduate { outline-title } else { [*#outline-title*] },
        indent: if not graduate { (0em, 1.8em, 1.3em) } else { (0em, 1.8em, 1.7em) },
        weight: if not graduate { ("bold", "regular", "regular") } else { (auto,) },
        fill: if not graduate { ([#repeat[#text(zh(5))[…]]],) } else { (repeat([.]),) },
        vspace: if not graduate { (1.25em, 1em) } else { (none,) },
        gap: if not graduate { (-0.5em, 0.5em) } else { (auto,) },
      )
    }

    #if graduate {
      pagebreak(weak: true, to: "odd")
    }
  ]

  [#metadata(none) <__nwpu_mainmatter_start__>]
  counter(page).update(1)

  // 5. 正文
  body

  // 6. 后置部分
  bilingual-bibliography(
    graduate: graduate,
    english-writing: english-writing,
  )

  if acknowledgement != none {
    backmatter-page(
      "acknowledgement",
      graduate: graduate,
      english-writing: english-writing,
    )[#acknowledgement]
  }

  if graduate and academic-achievements != none {
    backmatter-page(
      "academic-achievements",
      graduate: true,
      english-writing: english-writing,
    )[#academic-achievements]
  }

  if not graduate and design-summary != none {
    backmatter-page(
      "design-summary",
      english-writing: english-writing,
    )[#design-summary]
  }

  if appendix != none {
    show: appendix-layout.with(
      graduate: graduate,
      english-writing: english-writing,
    )
    [
      #heading(level: 1)[]
      #appendix
    ]
  }

  if graduate {
    pagebreak(weak: true, to: "odd")
  }

  // 尾部独立页面（声明、封底）：统一无页眉页脚、无边距
  set page(margin: 0pt, header: none, footer: none)

  if scan-declaration != none and graduate {
    page[
      #scan-declaration
      #box(width: 0pt, height: 0pt)
    ]
  }

  if colored-cover and graduate {
    let bg = if degree == "doctor" {
      "assets/doctor-back-cover.jpg"
    } else if track == "professional" {
      "assets/professional-back-cover.jpg"
    } else {
      "assets/academic-back-cover.jpg"
    }
    page[
      #box(width: 0pt, height: 0pt)
    ]
    page(
      background: image(bg, width: 100%, height: 100%),
    )[
      #box(width: 1pt, height: 1pt)
    ]
  }
}
