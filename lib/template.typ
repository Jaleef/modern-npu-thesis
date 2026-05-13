#import "deps.typ": (
  Assign, Break, Comment, Else, ElseIf, For, Function, If, IfElseChain, Line, LineBreak, Procedure, Return, Terminate,
  While, capfig, capfig-style, capsubfig, captab, captab-style, init-gb7714, multicite, zh,
)
#import "layouts/doc.typ": doc
#import "utils/algorithm.typ": algorithm, with-english-writing
#import "utils/equation-note.typ": equation-note
#import "layouts/mainmatter.typ": frontmatter, mainmatter
#import "layouts/appendix.typ": appendix as appendix-layout
#import "pages/bachelor-cover.typ": bachelor-cover
#import "pages/graduate-cover.typ": master-cover
#import "pages/abstract.typ": abstract-page
#import "pages/outline.typ": outline-page
#import "pages/backmatter-page.typ": backmatter-page
#import "pages/references.typ": bilingual-bibliography
#import "format.typ": heading-format, line-spacing, page-format
#import "utils/style.typ": chinese-chapter-number
#import "utils/cover-utils.typ": blind-review, distribute, page-title

#let default-bibliography(graduate) = {
  if not graduate {
    "../template/bib/bachelor.bib"
  } else {
    "../template/bib/graduate.bib"
  }
}

#let nwpu-thesis(
  graduate: false,
  degree: "master", // "master" | "doctor"（仅研究生）
  track: "academic", // "academic" | "professional"（仅研究生）
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
  bibliography: none,
  background: false,
  body,
) = {
  if bibliography == none {
    bibliography = default-bibliography(graduate)
  }

  // 1. 文稿设置
  show: doc.with(margin: if graduate { page-format.graduate-margin } else { page-format.bachelor-margin })

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
    let cover-content = bachelor-cover(
      anonymous: anonymous,
      info: info,
    )
    if background {
      page(background: image("../template/duibi/bachelor_cover.pdf", width: 100%, height: 100%))[#cover-content]
    } else {
      cover-content
    }
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
    leading: if graduate { line-spacing.graduate } else { line-spacing.bachelor },
    spacing: if graduate { line-spacing.graduate } else { line-spacing.bachelor },
    heading-above: if graduate { heading-format.graduate.above } else { heading-format.bachelor.above },
    heading-below: if graduate { heading-format.graduate.below } else { heading-format.bachelor.below },
    heading-numbering: (..nums) => {
      let nums = nums.pos()
      if nums.len() == 1 {
        if english-writing {
          [Chapter #nums.at(0)#h(0.7em)]
        } else if graduate {
          [第 #nums.at(0) 章#h(0.7em)]
        } else {
          [第#chinese-chapter-number(nums.at(0))章　]
        }
      } else if nums.len() <= 3 {
        numbering("1.1", ..nums)
      }
    },
  )

  // 4. 前置部分（摘要、目录）
  frontmatter[
    #if abstract.keys().len() > 0 {
      if graduate {
        let abstract-content = abstract-page(abstract: abstract)
        if background {
          page(background: image(
            "../template/duibi/graduate_abstract.pdf",
            width: 100%,
            height: 100%,
          ))[#abstract-content]
        } else {
          abstract-content
        }
      } else {
        let abstract-content = abstract-page(
          abstract: abstract,
          keyword-label: "关键词",
          keyword-sep: "，",
          keyword-indent: false,
          outline-title: page-title("abstract", graduate: graduate),
          outlined: false,
        )
        if background {
          page(background: image("../template/duibi/duibi.pdf", width: 100%, height: 100%))[#abstract-content]
        } else {
          abstract-content
        }
      }
    }
    #if abstract-en.keys().len() > 0 {
      if graduate {
        abstract-page(
          abstract: abstract-en,
          keyword-label: "Key words",
          keyword-weight: "bold",
          keyword-sep: "; ",
          keyword-indent: false,
          outline-title: "ABSTRACT",
          title: [*Abstract*],
        )
      } else {
        abstract-page(
          abstract: abstract-en,
          keyword-label: "KEY WORDS",
          keyword-weight: "bold",
          keyword-sep: ", ",
          keyword-indent: false,
          outline-title: "ABSTRACT",
          outlined: false,
        )
      }
    }

    #if graduate {
      let outline-content = outline-page(title: page-title("outline", graduate: true, english-writing: english-writing))
      if background {
        page(background: image("../template/duibi/graduate_outline.pdf", width: 100%, height: 100%))[#outline-content]
      } else {
        outline-content
      }
    } else {
      let outline-content = outline-page(
        title: [*#page-title("outline", graduate: false, english-writing: english-writing)*],
        indent: (0em, 1.8em, 1.3em),
        weight: ("bold", "regular", "regular"),
        fill: ([#repeat[#text(zh(5))[…]]],),
        vspace: (1.25em, 1em),
        gap: (-0.5em, 0.5em),
      )
      if background {
        page(background: image("../template/duibi/bachelor_outline.pdf", width: 100%, height: 100%))[#outline-content]
      } else {
        outline-content
      }
    }

    #if graduate {
      pagebreak(weak: true, to: "odd")
    }
  ]

  [#metadata(none) <__nwpu_mainmatter_start__>]
  counter(page).update(1)

  // 5. 正文
  with-english-writing(english-writing, body)

  // 6. 后置部分
  if bibliography != none {
    bilingual-bibliography(
      graduate: graduate,
      english-writing: english-writing,
    )
  }

  if graduate {
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

    if acknowledgement != none {
      backmatter-page(title: page-title(
        "acknowledgement",
        graduate: true,
        english-writing: english-writing,
      ))[#acknowledgement]
    }

    if academic-achievements != none {
      backmatter-page(
        title: page-title("academic-achievements", graduate: true, english-writing: english-writing),
      )[#academic-achievements]
    }
  } else {
    if acknowledgement != none {
      backmatter-page(title: page-title(
        "acknowledgement",
        graduate: false,
        english-writing: english-writing,
      ))[#acknowledgement]
    }

    if design-summary != none {
      backmatter-page(
        title: page-title("design-summary", english-writing: english-writing),
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
