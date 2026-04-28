#import "layouts/doc.typ": doc
#import "utils/algorithm.typ": algorithm, algorithm-ref, with-english-writing, indent, no-number, pseudocode-list
#import "utils/equation-note.typ": equation-note
#import "layouts/mainmatter.typ": mainmatter
#import "layouts/appendix.typ": appendix as appendix-layout
#import "utils/header.typ": graduate-header-title, header-render
#import "pages/bachelor-cover.typ": bachelor-cover
#import "pages/graduate-cover.typ": master-cover
#import "pages/abstract.typ": abstract as abstract-page
#import "pages/bachelor-outline.typ": bachelor-outline
#import "pages/graduate-outline.typ": graduate-outline
#import "pages/backmatter-page.typ": backmatter-page
#import "@preview/gb7714-bilingual:0.2.3": init-gb7714
#import "utils/bilingual-bibliography.typ": bilingual-bibliography
#import "utils/custom-heading.typ": active-heading, heading-display
#import "@preview/i-figured:0.2.4": show-equation, show-figure
#import "@preview/cap-able:0.0.2": captab, captnote, captab-style, capfig, capsubfig, capfig-style
#import "utils/style.typ": 字体, 字号
#import "format.typ": body-format, heading-format, header-format

#let appendix(title: auto, body) = (
  title: title,
  body: body,
)
#let appendices(..items) = items.pos()
#let bachelor-first-level-value(value) = if type(value) == array {
  value.at(0, default: value.last())
} else {
  value
}

#let normalize-graduate-appendix-items(legacy-appendix: none, appendices: none) = {
  if appendices != none {
    if type(appendices) == array {
      appendices
    } else {
      (appendices,)
    }
  } else if legacy-appendix != none {
    ((title: auto, body: legacy-appendix),)
  } else {
    ()
  }
}

#let render-graduate-appendices(legacy-appendix: none, appendices: none) = {
  let items = normalize-graduate-appendix-items(legacy-appendix: legacy-appendix, appendices: appendices)
  items
    .map(item => {
      let appendix-title = auto
      let appendix-body = item
      if type(item) == dictionary {
        appendix-title = item.at("title", default: auto)
        appendix-body = item.at("body", default: [])
      }

      [
        #heading(level: 1)[
          #if appendix-title != auto {
            appendix-title
          }
        ]
        #appendix-body
      ]
    })
    .join()
}

#let default-bibliography(doctype) = {
  if doctype == "bachelor" {
    "../template/bib/bachelor.bib"
  } else {
    "../template/bib/graduate.bib"
  }
}

#let bachelor-thesis-config(
  degree: "academic",
  anonymous: false,
  english-writing: false,
  title: ("基于 Typst 的", "西北工业大学毕业论文"),
  author: "张三",
  major: "某专业",
  supervisor: ("李四", "教授"),
  submit-date: (year: 2026, month: 6),
  abstract: none,
  keywords: (),
  abstract-en: none,
  keywords-en: (),
  acknowledgement: none,
  appendix: none,
  design_summary: none,
) = {
  (
    doctype: "bachelor",
    degree: degree,
    anonymous: anonymous,
    english-writing: english-writing,
    colored-cover: false,
    info: (
      title: title,
      author: author,
      major: major,
      supervisor: supervisor,
      submit-date: submit-date,
    ),
    abstract: abstract,
    keywords: keywords,
    abstract-en: abstract-en,
    keywords-en: keywords-en,
    acknowledgement: acknowledgement,
    appendix: appendix,
    design_summary: design_summary,
  )
}

#let graduate-thesis-config(
  doctype: "master",
  degree: "academic",
  anonymous: false,
  english-writing: false,
  colored-cover: false,
  title: ("基于 Typst 的", "西北工业大学学位论文"),
  title-en: "NPU Thesis Template for Typst",
  student-id: "1234567890",
  class-no: "O643.12",
  author: "张三",
  author-en: "Zhang San",
  department: "某学院",
  major: "某专业",
  major-en: "XX",
  supervisor: ("李四", "教授"),
  supervisor-en: "Li Si",
  submit-date: datetime.today(),
  reviewers: (
    (name: "", title: "", unit: ""),
    (name: "", title: "", unit: ""),
  ),
  defence-committee: (
    date: datetime.today(),
    chairman: (name: "", title: "", unit: ""),
    members: (
      (name: "", title: "", unit: ""),
      (name: "", title: "", unit: ""),
      (name: "", title: "", unit: ""),
      (name: "", title: "", unit: ""),
    ),
    secretary: (name: "", title: "", unit: ""),
  ),
  abstract: none,
  keywords: (),
  funding: none,
  abstract-en: none,
  keywords-en: (),
  funding-en: none,
  acknowledgement: none,
  academic-achievements: none,
  appendix: none,
  appendices: none,
  scan-declaration: none,
) = {
  (
    doctype: doctype,
    degree: degree,
    anonymous: anonymous,
    english-writing: english-writing,
    colored-cover: colored-cover,
    info: (
      title: title,
      title-en: title-en,
      student-id: student-id,
      class-no: class-no,
      author: author,
      author-en: author-en,
      department: department,
      major: major,
      major-en: major-en,
      supervisor: supervisor,
      supervisor-en: supervisor-en,
      submit-date: submit-date,
      reviewers: reviewers,
      defence-committee: defence-committee,
    ),
    abstract: abstract,
    keywords: keywords,
    funding: funding,
    abstract-en: abstract-en,
    keywords-en: keywords-en,
    funding-en: funding-en,
    acknowledgement: acknowledgement,
    academic-achievements: academic-achievements,
    appendix: appendix,
    appendices: appendices,
    scan-declaration: scan-declaration,
  )
}

// ========== 命令行参数支持 ==========
#let _parse-bool(value, default) = {
  if value == none { default } else if value == "true" or value == "1" {
    true
  } else if value == "false" or value == "0" { false } else { default }
}

// 主配置函数（借鉴自 pkuthss-typst，提供更简洁的接口）
#let nwpu-thesis(
  doctype: "bachelor", // "bachelor" | "master" | "doctor"
  degree: "academic", // "academic" | "professional"
  english-writing: false,
  colored-cover: false,
  anonymous: false,
  info: (:),
  bibliography: none,
  // 页面控制
  abstract: none,
  keywords: (),
  funding: none,
  abstract-en: none,
  keywords-en: (),
  funding-en: none,
  acknowledgement: none,
  academic-achievements: none,
  scan-declaration: none,
  appendix: none,
  appendices: none,
  design_summary: none,
  // 文档内容
  body,
) = {
  if bibliography == none {
    bibliography = default-bibliography(doctype)
  }

  // 命令行参数覆盖
  let anonymous = _parse-bool(sys.inputs.at("anonymous", default: none), anonymous)
  let effective_twoside = if doctype == "bachelor" {
    false
  } else {
    _parse-bool(sys.inputs.at("twoside", default: none), true)
  }
  let english-writing = _parse-bool(sys.inputs.at("english-writing", default: none), english-writing)
  let colored-cover = _parse-bool(sys.inputs.at("colored-cover", default: none), colored-cover)
  let graduate-appendix-items = normalize-graduate-appendix-items(
    legacy-appendix: appendix,
    appendices: appendices,
  )
  let has-graduate-appendices = graduate-appendix-items.len() > 0
  let close-backmatter-section = has-more-content => {
    if effective_twoside {
      if has-more-content {
        pagebreak(to: "odd")
      } else if colored-cover and (doctype == "master" or doctype == "doctor") {
        []
      } else {
        pagebreak(to: "even")
      }
    }
  }

  // 默认参数
  let fonts = 字体
  info = (
    (
      title: ("基于 Typst 的", "西北工业大学学位论文"),
      title-en: "NPU Thesis Template for Typst",
      student-id: "1234567890",
      author: "张三",
      author-en: "Zhang San",
      department: "某学院",
      department-en: "XX School",
      major: "某专业",
      major-en: "XX",
      supervisor: ("李四", "教授"),
      supervisor-en: "Li Si",
      submit-date: datetime.today(),
      reviewer: ("某某某 教授", "某某某 教授"),
      defend-date: datetime.today(),
      class-no: "O643.12",
      secret-level: "公开",
      school-code: "10699",
      degree: auto,
      degree-en: auto,
      // 评阅人名单，每人包含 name、title、unit
      reviewers: (
        (name: "", title: "", unit: ""),
        (name: "", title: "", unit: ""),
        (name: "", title: "", unit: ""),
      ),
      // 答辩委员会信息
      defence-committee: (
        date: datetime.today(),
        chairman: (name: "", title: "", unit: ""),
        members: (
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
        ),
        secretary: (name: "", title: "", unit: ""),
      ),
    )
      + info
  )

  let cls = (
    doc: (..args) => {
      doc(
        ..args,
        doctype: doctype,
        degree: degree,
        colored-cover: colored-cover,
        graduate_header_ascent: header-format.graduate.ascent,
        info: info + args.named().at("info", default: (:)),
      )
    },
    mainmatter: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        mainmatter(
          twoside: effective_twoside,
          doctype: doctype,
          english-writing: english-writing,
          heading-pagebreak: (true, false, false),
          graduate-leading: body-format.graduate.leading,
          graduate-spacing: body-format.graduate.spacing,
          heading_leading: heading-format.graduate.leading,
          heading-above: heading-format.graduate.above,
          heading-below: heading-format.graduate.below,
          graduate_headsep: header-format.graduate.headsep,
          graduate_headrule_offset: header-format.graduate.headrule-offset,
          graduate_headrule_thick: header-format.graduate.headrule-thick,
          graduate_headrule_thin: header-format.graduate.headrule-thin,
          graduate_headrule_gap: header-format.graduate.headrule-gap,
          display-header: true,
          body-font: fonts.宋体,
          body-size: 字号.小四,
          ..args,
          fonts: 字体 + args.named().at("fonts", default: (:)),
        )
      } else {
        mainmatter(
          twoside: effective_twoside,
          doctype: doctype,
          english-writing: english-writing,
          heading-pagebreak: (true, false, false),
          bachelor_leading: body-format.bachelor.leading,
          bachelor_spacing: body-format.bachelor.spacing,
          bachelor_heading_leading: heading-format.bachelor.leading,
          bachelor_heading_above: heading-format.bachelor.above,
          bachelor_heading_below: heading-format.bachelor.below,
          display-header: true,
          body-font: fonts.宋体,
          body-size: 字号.小四,
          ..args,
          fonts: 字体 + args.named().at("fonts", default: (:)),
        )
      }
    },
    appendix: (..args) => {
      appendix-layout(
        twoside: effective_twoside,
        doctype: doctype,
        english-writing: english-writing,
        body-font: fonts.宋体,
        body-size: 字号.小四,
        leading: if doctype == "bachelor" { body-format.bachelor.leading } else { body-format.graduate.leading },
        spacing: if doctype == "bachelor" { body-format.bachelor.spacing } else { body-format.graduate.spacing },
        ..args,
      )
    },
    cover: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-cover(
          doctype: doctype,
          degree: degree,
          colored-cover: colored-cover,
          anonymous: anonymous,
          twoside: effective_twoside,
          ..args,
          info: info + args.named().at("info", default: (:)),
        )
      } else {
        bachelor-cover(
          anonymous: anonymous,
          twoside: effective_twoside,
          ..args,
          info: info + args.named().at("info", default: (:)),
        )
      }
    },
    abstract: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        abstract-page(
          keywords-above: body-format.graduate.keywords-above,
          ..args,
        )
      } else {
        abstract-page(
          ..args,
          keyword-label: "关键词",
          keyword-sep: "，",
          keyword-indent: 0pt,
          outline-title: "摘 要",
          outlined: false,
          funding: none,
        )
      }
    },
    abstract-en: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        abstract-page(
          keywords-above: body-format.graduate.keywords-above,
          keyword-label: "Key words",
          keyword-weight: "bold",
          keyword-sep: "; ",
          outline-title: "Abstract",
          heading-metadata: true,
          ..args,
        )
      } else {
        abstract-page(
          ..args,
          keyword-label: "KEY WORDS",
          keyword-weight: "bold",
          keyword-sep: ", ",
          keyword-indent: 0pt,
          outline-title: "ABSTRACT",
          outlined: false,
          funding: none,
        )
      }
    },
    outline-page: (..args) => {
      if doctype == "bachelor" {
        bachelor-outline(
          english-writing: english-writing,
          ..args,
        )
      } else {
        graduate-outline(
          english-writing: english-writing,
          ..args,
        )
      }
    },
    bilingual-bibliography: (..args) => {
      bilingual-bibliography(
        doctype: doctype,
        english-writing: english-writing,
        fonts: 字体 + args.named().at("fonts", default: (:)),
        ..args,
      )
    },
    acknowledgement: (..args) => {
      backmatter-page(
        title: if english-writing {
          "Acknowledgements"
        } else if doctype == "bachelor" {
          "致 谢"
        } else {
          "致　谢"
        },
        ..args,
      )
    },
    academic-achievements: (..args) => {
      backmatter-page(
        title: if english-writing {
          "Academic Achievements and Research Experience"
        } else {
          "在学期间取得的学术成果和参加科研情况"
        },
        ..args,
      )
    },
  )

  show: cls.doc

  // 1. 封面
  (cls.cover)()

  show: init-gb7714.with(read(bibliography), style: "numeric", version: "2015")

  // mainmatter 包裹所有后续内容（前置 + 正文 + 后置）
  show: cls.mainmatter

  // 2. 前置部分（摘要、目录）：覆盖页码和标题编号
  [
    #set page(footer: context align(center)[
      #set text(size: 字号.小五)
      #counter(page).display("I")
    ])
    #set heading(numbering: none)
    #counter(page).update(1)
    #if abstract != none {
      if doctype == "bachelor" {
        (cls.abstract)(keywords: keywords)[#abstract]
      } else {
        (cls.abstract)(keywords: keywords, funding: funding)[#abstract]
      }
    }
    #if abstract-en != none {
      if doctype == "bachelor" {
        (cls.abstract-en)(keywords: keywords-en)[#abstract-en]
      } else {
        (cls.abstract-en)(keywords: keywords-en, funding: funding-en)[#abstract-en]
      }
    }

    #(cls.outline-page)(depth: 3)

    #if effective_twoside {
      pagebreak(weak: true, to: "odd")
    }
  ]

  [#metadata(none) <__nwpu_mainmatter_start__>]
  counter(page).update(1)

  // 3. 正文
  with-english-writing(english-writing, body)

  // 4. 后置部分
  if bibliography != none {
    (cls.bilingual-bibliography)()
    close-backmatter-section(
      if doctype == "bachelor" {
        (
          acknowledgement != none or design_summary != none or appendix != none or scan-declaration != none
        )
      } else {
        (
          has-graduate-appendices
            or acknowledgement != none
            or academic-achievements != none
            or scan-declaration != none
        )
      },
    )
  }

  if doctype == "bachelor" {
    if acknowledgement != none {
      (cls.acknowledgement)(acknowledgement)
      close-backmatter-section(design_summary != none or appendix != none or scan-declaration != none)
    }

    if design_summary != none {
      backmatter-page(
        title: if english-writing { "Design Summary" } else { "毕业设计小结" },
      )[#design_summary]
      close-backmatter-section(appendix != none or scan-declaration != none)
    }

    if appendix != none {
      show: cls.appendix
      [
        #heading(level: 1)[]
        #appendix
      ]
      close-backmatter-section(scan-declaration != none)
    }
  } else {
    if has-graduate-appendices {
      show: cls.appendix
      render-graduate-appendices(legacy-appendix: appendix, appendices: appendices)
      close-backmatter-section(
        acknowledgement != none or academic-achievements != none or scan-declaration != none,
      )
    }

    if acknowledgement != none {
      (cls.acknowledgement)(acknowledgement)
      close-backmatter-section(
        academic-achievements != none or scan-declaration != none,
      )
    }

    if academic-achievements != none {
      (cls.academic-achievements)(academic-achievements)
      close-backmatter-section(scan-declaration != none)
    }
  }

  if scan-declaration != none and doctype != "bachelor" {
    page(
      margin: 0pt,
      header: none,
      footer: none,
    )[
      #scan-declaration
      #box(width: 0pt, height: 0pt) <__nwpu_backmatter_end__>
    ]
  } else {
    [#box(width: 0pt, height: 0pt) <__nwpu_backmatter_end__>]
  }

  if colored-cover and (doctype == "master" or doctype == "doctor") {
    let bg = if doctype == "doctor" {
      "../template/figures/博士论文封底.jpg"
    } else if degree == "professional" {
      "../template/figures/专硕论文封底.jpg"
    } else {
      "../template/figures/学硕论文封底.jpg"
    }
    let back-margin = (top: 2.54cm, bottom: 2.54cm, left: 2.5cm, right: 2.5cm)
    let parity-blank-page = page(
      margin: back-margin,
      header: header-render(
        graduate-header-title(doctype),
        fonts: 字体,
        graduate_headsep: header-format.graduate.headsep,
        graduate_headrule_offset: header-format.graduate.headrule-offset,
        graduate_headrule_thick: header-format.graduate.headrule-thick,
        graduate_headrule_thin: header-format.graduate.headrule-thin,
        graduate_headrule_gap: header-format.graduate.headrule-gap,
      ),
      footer: context align(center)[
        #set text(size: 字号.小五)
        #counter(page).display("1")
      ],
    )[
      #box(width: 1pt, height: 1pt)
    ]
    let blank-back-page = page(margin: back-margin, background: none, header: none, footer: none)[
      #box(width: 1pt, height: 1pt)
    ]
    let cover-back-page = page(
      margin: 0pt,
      background: image(bg, width: 100%, height: 100%),
      header: none,
      footer: none,
    )[
      #box(width: 1pt, height: 1pt)
    ]

    context {
      let end-page = counter(page).at(<__nwpu_backmatter_end__>).first()

      if calc.rem(end-page, 2) == 1 {
        if scan-declaration != none {
          blank-back-page
        } else {
          parity-blank-page
        }
      }
      blank-back-page
      cover-back-page
    }
  }
}

