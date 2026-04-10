#import "lib/layouts/doc.typ": doc
#import "lib/utils/algorithm.typ": algorithm, algorithm-ref, reset-algorithm-counter, with-english-writing
#import "lib/layouts/preface.typ": preface
#import "lib/layouts/mainmatter.typ": mainmatter
#import "lib/layouts/appendix.typ": appendix
#import "lib/utils/header.typ": add-blank-even-page
#import "lib/utils/header.typ": break-to-odd-page
#import "lib/utils/header.typ": graduate-header-title, header-render
#import "lib/pages/bachelor-cover.typ": bachelor-cover
#import "lib/pages/master-cover.typ": master-cover
#import "lib/pages/bachelor-abstract.typ": bachelor-abstract
#import "lib/pages/master-abstract.typ": master-abstract
#import "lib/pages/bachelor-abstract-en.typ": bachelor-abstract-en
#import "lib/pages/master-abstract-en.typ": master-abstract-en
#import "lib/pages/outline-page.typ": outline-page
#import "lib/pages/acknowledgement.typ": acknowledgement
#import "lib/pages/design-summary.typ": design-summary as design-summary-page
#import "lib/pages/academic-achievements.typ": academic-achievements
#import "lib/utils/custom-cuti.typ": *
#import "lib/utils/bilingual-bibliography.typ": bilingual-bibliography
#import "lib/utils/custom-numbering.typ": custom-numbering
#import "lib/utils/custom-heading.typ": active-heading, current-heading, heading-display
#import "@preview/i-figured:0.2.4": show-equation, show-figure
#import "lib/utils/style.typ": 字体, 字号

#let indent = h(2em)
#let bachelor-first-level-value(value) = if type(value) == array {
  value.at(0, default: value.last())
} else {
  value
}

#let bachelor_style_defaults = (
  leading: 11pt,
  spacing: 10pt,
  heading_leading: (11pt, 11pt, 11pt),
  heading_above: (28pt, 12pt, 12pt),
  heading_below: (28pt, 12pt, 12pt),
)

#let bachelor-thesis-config(
  degree: "academic",
  anonymous: false,
  english-writing: false,
  fonts: (:),
  title: ("基于 Typst 的", "西北工业大学毕业论文"),
  author: "张三",
  major: "某专业",
  supervisor: ("李四", "教授"),
  submit-date: (year: 2026, month: 6),
  bibliography: none,
  abstract: none,
  keywords: (),
  abstract-en: none,
  keywords-en: (),
  acknowledgement: none,
  appendix: none,
  design_summary: none,
  outline-depth: 2,
  bachelor_leading: bachelor_style_defaults.leading,
  bachelor_spacing: bachelor_style_defaults.spacing,
  bachelor_heading_leading: bachelor_style_defaults.heading_leading,
  bachelor_heading_above: bachelor_style_defaults.heading_above,
  bachelor_heading_below: bachelor_style_defaults.heading_below,
  info_extra: (:),
  config_extra: (:),
) = {
  (
    doctype: "bachelor",
    degree: degree,
    anonymous: anonymous,
    english-writing: english-writing,
    colored-cover: false,
    fonts: fonts,
    info: (
      title: title,
      author: author,
      major: major,
      supervisor: supervisor,
      submit-date: submit-date,
    ) + info_extra,
    bibliography: bibliography,
    abstract: abstract,
    keywords: keywords,
    abstract-en: abstract-en,
    keywords-en: keywords-en,
    acknowledgement: acknowledgement,
    appendix: appendix,
    design_summary: design_summary,
    outline-depth: outline-depth,
    bachelor_leading: bachelor_leading,
    bachelor_spacing: bachelor_spacing,
    bachelor_heading_leading: bachelor_heading_leading,
    bachelor_heading_above: bachelor_heading_above,
    bachelor_heading_below: bachelor_heading_below,
  ) + config_extra
}

#let graduate-thesis-config(
  doctype: "master",
  degree: "academic",
  anonymous: false,
  english-writing: false,
  colored-cover: false,
  fonts: (:),
  title: ("基于 Typst 的", "西北工业大学学位论文"),
  title-en: "NPU Thesis Template for Typst",
  student-id: "1234567890",
  clc: "O643.12",
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
  bibliography: none,
  abstract: none,
  keywords: (),
  funding: none,
  abstract-en: none,
  keywords-en: (),
  funding-en: none,
  acknowledgement: none,
  academic-achievements: none,
  appendix: none,
  scan-declaration: none,
  outline-depth: 3,
  info_extra: (:),
  config_extra: (:),
) = {
  (
    doctype: doctype,
    degree: degree,
    anonymous: anonymous,
    english-writing: english-writing,
    colored-cover: colored-cover,
    fonts: fonts,
    info: (
      title: title,
      title-en: title-en,
      student-id: student-id,
      clc: clc,
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
    ) + info_extra,
    bibliography: bibliography,
    abstract: abstract,
    keywords: keywords,
    funding: funding,
    abstract-en: abstract-en,
    keywords-en: keywords-en,
    funding-en: funding-en,
    acknowledgement: acknowledgement,
    academic-achievements: academic-achievements,
    appendix: appendix,
    scan-declaration: scan-declaration,
    outline-depth: outline-depth,
  ) + config_extra
}

// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
#let documentclass(
  doctype: "bachelor", // "bachelor" | "master" | "doctor" | "postdoc"，文档类型，默认为本科生 bachelor
  degree: "academic", // "academic" | "professional"，学位类型，默认为学术型 academic
  nl-cover: false, // TODO: 是否使用国家图书馆封面，默认关闭
  twoside: true, // 双面模式，会加入空白页，便于打印
  english-writing: false, // 是否使用英文论文标签
  bachelor_leading: bachelor_style_defaults.leading, // 本科论文统一行距增量
  bachelor_spacing: bachelor_style_defaults.spacing, // 本科论文统一段间距
  bachelor_heading_leading: bachelor_style_defaults.heading_leading, // 本科正文各级标题行距
  bachelor_heading_above: bachelor_style_defaults.heading_above, // 本科正文各级标题段前距
  bachelor_heading_below: bachelor_style_defaults.heading_below, // 本科正文各级标题段后距
  colored-cover: false, // 是否开启彩色封面封底
  anonymous: false, // 盲审模式
  bibliography: none, // 原来的参考文献函数
  fonts: (:), // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  fonts = 字体 + fonts
  info = (
    (
      title: ("基于 Typst 的", "西北工业大学学位论文"),
      title-en: "NPU Thesis Template for Typst",
      grade: "20XX",
      student-id: "1234567890",
      author: "张三",
      author-en: "Zhang San",
      department: "某学院",
      department-en: "XX School",
      major: "某专业",
      major-en: "XX",
      field: "某方向",
      field-en: "XX Field",
      supervisor: ("李四", "教授"),
      supervisor-en: "Li Si",
      supervisor-ii: (),
      supervisor-ii-en: "",
      submit-date: datetime.today(),
      // 以下为研究生项
      defend-date: datetime.today(),
      confer-date: datetime.today(),
      bottom-date: datetime.today(),
      chairman: "某某某 教授",
      reviewer: ("某某某 教授", "某某某 教授"),
      clc: "O643.12",
      udc: "544.4",
      secret-level: "公开",
      supervisor-contact: "西北工业大学 陕西省西安市长安区东大街道",
      email: "xxx@mail.nwpu.edu.cn",
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
        // 固定主席
        chairman: (name: "", title: "", unit: ""),
        // 委员列表，每人包含 name、title、unit
        members: (
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
          (name: "", title: "", unit: ""),
        ),
        // 固定秘书
        secretary: (name: "", title: "", unit: ""),
      ),
    )
      + info
  )

  return (
    // 将传入参数再导出
    doctype: doctype,
    degree: degree,
    nl-cover: nl-cover,
    twoside: twoside,
    english-writing: english-writing,
    bachelor_leading: bachelor_leading,
    bachelor_spacing: bachelor_spacing,
    bachelor_heading_leading: bachelor_heading_leading,
    bachelor_heading_above: bachelor_heading_above,
    bachelor_heading_below: bachelor_heading_below,
    anonymous: anonymous,
    fonts: fonts,
    info: info,
    // 页面布局
    doc: (..args) => {
      doc(
        ..args,
        doctype: doctype,
        degree: degree,
        colored-cover: colored-cover,
        info: info + args.named().at("info", default: (:)),
      )
    },
    preface: (it, ..args) => {
        preface(
          twoside: twoside,
          doctype: doctype,
          display-header: true,
          fonts: fonts + args.named().at("fonts", default: (:)),
          ..args,
          it,
      )
    },
    mainmatter: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        mainmatter(
          twoside: twoside,
          doctype: doctype,
          english-writing: english-writing,
          display-header: true,
          bachelor_leading: bachelor_leading,
          bachelor_spacing: bachelor_spacing,
          bachelor_heading_leading: bachelor_heading_leading,
          bachelor_heading_above: bachelor_heading_above,
          bachelor_heading_below: bachelor_heading_below,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else {
        mainmatter(
          twoside: twoside,
          doctype: doctype,
          english-writing: english-writing,
          display-header: true,
          bachelor_leading: bachelor_leading,
          bachelor_spacing: bachelor_spacing,
          bachelor_heading_leading: bachelor_heading_leading,
          bachelor_heading_above: bachelor_heading_above,
          bachelor_heading_below: bachelor_heading_below,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },
    appendix: (..args) => {
      appendix(
        twoside: twoside,
        doctype: doctype,
        english-writing: english-writing,
        ..args,
      )
    },
    // 封面页，通过 type 分发到不同函数
    cover: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-cover(
          doctype: doctype,
          degree: degree,
          colored-cover: colored-cover,
          nl-cover: nl-cover,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-cover(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 中文摘要页，通过 type 分发到不同函数
    abstract: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract(
          anonymous: anonymous,
          twoside: twoside,
          leading: bachelor_leading,
          spacing: bachelor_spacing,
          title-leading: bachelor-first-level-value(bachelor_heading_leading),
          title-above: bachelor-first-level-value(bachelor_heading_above),
          title-below: bachelor-first-level-value(bachelor_heading_below),
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },
    // 英文摘要页，通过 type 分发到不同函数
    abstract-en: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract-en(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract-en(
          anonymous: anonymous,
          twoside: twoside,
          leading: bachelor_leading,
          spacing: bachelor_spacing,
          title-leading: bachelor-first-level-value(bachelor_heading_leading),
          title-above: bachelor-first-level-value(bachelor_heading_above),
          title-below: bachelor-first-level-value(bachelor_heading_below),
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },
    // 目录页
    outline-page: (..args) => {
      outline-page(
        twoside: twoside,
        doctype: doctype,
        leading: if doctype == "bachelor" { bachelor_leading } else { auto },
        spacing: if doctype == "bachelor" { bachelor_spacing } else { 0pt },
        title-leading: if doctype == "bachelor" { bachelor-first-level-value(bachelor_heading_leading) } else { auto },
        title-above: if doctype == "bachelor" { bachelor-first-level-value(bachelor_heading_above) } else { auto },
        title-below: if doctype == "bachelor" { bachelor-first-level-value(bachelor_heading_below) } else { auto },
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    // 参考文献页
    bilingual-bibliography: (..args) => {
      bilingual-bibliography(
        bibliography: bibliography,
        doctype: doctype,
        twoside: twoside,
        ..args,
      )
    },
    // 致谢页
    acknowledgement: (..args) => {
      acknowledgement(
        anonymous: anonymous,
        twoside: twoside,
        doctype: doctype,
        leading: bachelor_leading,
        spacing: bachelor_spacing,
        title-leading: bachelor-first-level-value(bachelor_heading_leading),
        title-above: bachelor-first-level-value(bachelor_heading_above),
        title-below: bachelor-first-level-value(bachelor_heading_below),
        fonts: fonts + args.named().at("fonts", default: (:)),
        ..args,
      )
    },
    // 学术成果页（西工大研究生特有）
    academic-achievements: (..args) => {
      academic-achievements(
        anonymous: anonymous,
        twoside: twoside,
        fonts: fonts + args.named().at("fonts", default: (:)),
        ..args,
      )
    },
    // 空白偶数页（双面打印用）
    add-blank-even-page: (..args) => {
      add-blank-even-page(
        doctype: doctype,
        fonts: fonts + args.named().at("fonts", default: (:)),
        ..args,
      )
    },
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
  doctype: "bachelor", // "bachelor" | "master" | "doctor" | "postdoc"
  degree: "academic", // "academic" | "professional"
  nl-cover: false,
  twoside: true,
  english-writing: false,
  bachelor_leading: bachelor_style_defaults.leading,
  bachelor_spacing: bachelor_style_defaults.spacing,
  bachelor_heading_leading: bachelor_style_defaults.heading_leading,
  bachelor_heading_above: bachelor_style_defaults.heading_above,
  bachelor_heading_below: bachelor_style_defaults.heading_below,
  colored-cover: false,
  anonymous: false,
  fonts: (:),
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
  design_summary: none,
  outline-depth: auto,
  // 文档内容
  body,
) = {
  // 命令行参数覆盖
  let anonymous = _parse-bool(sys.inputs.at("anonymous", default: none), anonymous)
  let twoside = _parse-bool(sys.inputs.at("twoside", default: none), twoside)
  let english-writing = _parse-bool(sys.inputs.at("english-writing", default: none), english-writing)
  let effective_twoside = if doctype == "bachelor" { false } else { twoside }
  let colored-cover = _parse-bool(sys.inputs.at("colored-cover", default: none), colored-cover)
  if outline-depth == auto {
    outline-depth = if doctype == "bachelor" { 2 } else { 3 }
  }
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

  let cls = documentclass(
    doctype: doctype,
    degree: degree,
    nl-cover: nl-cover,
    twoside: effective_twoside,
    english-writing: english-writing,
    bachelor_leading: bachelor_leading,
    bachelor_spacing: bachelor_spacing,
    bachelor_heading_leading: bachelor_heading_leading,
    bachelor_heading_above: bachelor_heading_above,
    bachelor_heading_below: bachelor_heading_below,
    colored-cover: colored-cover,
    anonymous: anonymous,
    fonts: fonts,
    info: info,
    bibliography: bibliography,
  )

  show: cls.doc

  // 1. 封面
  (cls.cover)()

  // 2. 前置部分（摘要、目录等）
  show: cls.preface
  if abstract != none {
    (cls.abstract)(keywords: keywords, funding: funding)[#abstract]
  }
  if abstract-en != none {
    (cls.abstract-en)(keywords: keywords-en, funding: funding-en)[#abstract-en]
  }

  (cls.outline-page)(depth: outline-depth)

  // 3. 正文
  [#box(width: 0pt, height: 0pt) <__nwpu_mainmatter_start__>]
  show: cls.mainmatter
  with-english-writing(english-writing, body)

  // 4. 后置部分
  // 参考文献
  if bibliography != none {
    (cls.bilingual-bibliography)()
    close-backmatter-section(
      if doctype == "bachelor" {
        (
          acknowledgement != none
          or design_summary != none
          or appendix != none
          or scan-declaration != none
        )
      } else {
        (
          appendix != none
          or acknowledgement != none
          or academic-achievements != none
          or scan-declaration != none
        )
      }
    )
  }

  if doctype == "bachelor" {
    if acknowledgement != none {
      (cls.acknowledgement)(acknowledgement)
      close-backmatter-section(design_summary != none or appendix != none or scan-declaration != none)
    }

    if design_summary != none {
      design-summary-page(
        twoside: effective_twoside,
        fonts: fonts,
        leading: bachelor_leading,
        spacing: bachelor_spacing,
        title-leading: bachelor-first-level-value(bachelor_heading_leading),
        title-above: bachelor-first-level-value(bachelor_heading_above),
        title-below: bachelor-first-level-value(bachelor_heading_below),
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
    // 附录
    if appendix != none {
      show: cls.appendix
      appendix
      close-backmatter-section(
        acknowledgement != none
          or academic-achievements != none
          or scan-declaration != none,
      )
    }

    // 致谢
    if acknowledgement != none {
      (cls.acknowledgement)(acknowledgement)
      close-backmatter-section(
        academic-achievements != none
          or scan-declaration != none,
      )
    }

    // 学术成果
    if academic-achievements != none {
      (cls.academic-achievements)(academic-achievements)
      close-backmatter-section(scan-declaration != none)
    }
  }

  // 声明扫描页
  if scan-declaration != none and doctype != "bachelor" {
    page(margin: 0pt)[
      #scan-declaration
      #box(width: 0pt, height: 0pt) <__nwpu_backmatter_end__>
    ]
  } else {
    [#box(width: 0pt, height: 0pt) <__nwpu_backmatter_end__>]
  }

  if colored-cover and (doctype == "master" or doctype == "doctor") {
    let bg = if doctype == "doctor" {
      "template/images/博士论文封底.jpg"
    } else if degree == "professional" {
      "template/images/专硕论文封底.jpg"
    } else {
      "template/images/学硕论文封底.jpg"
    }
    let back-margin = (top: 2.54cm, bottom: 2.54cm, left: 2.5cm, right: 2.5cm)
    let parity-blank-page = page(
      margin: back-margin,
      header: header-render(graduate-header-title(doctype), fonts: cls.fonts),
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

