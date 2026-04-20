#import "@preview/gb7714-bilingual:0.2.3": gb7714-bibliography
#import "../utils/style.typ": 字体, 字号
#import "../layouts/preface.typ": preface-heading-style, preface-heading-above, preface-heading-below, preface-heading-leading, preface-body-leading, preface-body-spacing, preface-body-first-line-indent

#let normalize-patent-owner(owner) = {
  if owner == none { return "" }
  str(owner).replace(regex("\s+and\s+"), "、")
}

#let normalize-biblio-names(names, lang: "zh") = {
  if names == none { return "" }
  let text = str(names)
  if lang == "zh" {
    text.replace(regex("\s+and\s+"), "、")
  } else {
    text.replace(regex("\s+and\s+"), ", ")
  }
}

#let is-custom-standard-entry(entry) = {
  let raw-type = lower(str(entry.entry-type))
  let fields = entry.fields
  let mark = upper(str(fields.at("mark", default: fields.at("usera", default: ""))))
  let subtype = lower(str(fields.at("entrysubtype", default: "")))
  let note = lower(str(fields.at("note", default: "")))
  let number = upper(str(fields.at("number", default: fields.at("serial-number", default: ""))))
  let std-prefixes = ("GB", "ISO", "IEC", "IEEE", "ANSI", "DIN", "JIS", "BS")

  return (
    raw-type == "standard"
      or mark == "S"
      or ((raw-type == "book" or raw-type == "inbook" or raw-type == "unknown") and (subtype == "standard" or note == "standard"))
      or ((raw-type == "unknown" or raw-type == "misc") and std-prefixes.any(prefix => number.starts-with(prefix)))
  )
}

#let is-custom-other-entry(entry) = {
  let raw-type = lower(str(entry.entry-type))
  let fields = entry.fields
  let subtype = lower(str(fields.at("entrysubtype", default: "")))
  let note = lower(str(fields.at("note", default: "")))
  let mark = str(fields.at("mark", default: fields.at("usera", default: "")))
  let medium = str(fields.at("medium", default: ""))
  let url = str(fields.at("url", default: fields.at("howpublished", default: "")))

  return (
    raw-type == "other"
      or subtype == "other"
      or note == "other"
      or (raw-type in ("misc", "unknown") and url != "" and mark == "" and medium == "")
  )
}

#let render-custom-patent(entry) = {
  let fields = entry.fields
  let owner = normalize-patent-owner(fields.at("author", default: fields.at("holder", default: "")))
  let title = fields.at("title", default: "")
  let country = fields.at("location", default: fields.at("address", default: ""))
  let patent-number = fields.at("number", default: fields.at("call-number", default: ""))
  let publish-date = fields.at("date", default: fields.at("issued", default: fields.at("year", default: "")))

  let body = []
  if owner != "" {
    body += [#owner. ]
  }
  body += [#title]
  body += [[P]. ]
  if country != "" {
    body += [#country: ]
  }
  if patent-number != "" {
    body += [#patent-number]
  }
  if patent-number != "" and publish-date != "" {
    body += [, ]
  }
  if publish-date != "" {
    body += [#publish-date]
  }
  body += [. #entry.ref-label]
  body
}

#let render-custom-conference(entry, doctype: "master") = {
  let fields = entry.fields
  let lang = entry.lang
  let author = normalize-biblio-names(fields.at("author", default: ""), lang: lang)
  let editor = normalize-biblio-names(
    fields.at("editor", default: fields.at("bookauthor", default: "")),
    lang: lang,
  )
  let title = fields.at("title", default: "")
  let proceedings-title = fields.at("booktitle", default: fields.at("titleaddon", default: ""))
  let location = fields.at("location", default: fields.at("address", default: ""))
  let publisher = fields.at("publisher", default: fields.at("institution", default: ""))
  let year = str(fields.at("year", default: fields.at("date", default: "")))
  let pages = str(fields.at("pages", default: "")).replace("--", "-")
  let is-graduate = doctype == "master" or doctype == "doctor"
  let in-prefix = if lang == "zh" { "见：" } else { "In: " }
  let pub-sep = if lang == "zh" { "：" } else { ": " }
  let year-sep = if lang == "zh" { "，" } else { ", " }

  let body = []
  if author != "" {
    body += [#author. ]
  }
  body += [#title]
  if is-graduate {
    body += [[C]. ]
  } else {
    body += [[A]. ]
    body += [#in-prefix]
    if editor != "" {
      body += [#editor. ]
    }
    if proceedings-title != "" {
      body += [#proceedings-title]
      body += [[C]. ]
    }
  }
  if location != "" {
    body += [#location#pub-sep]
  }
  if publisher != "" {
    body += [#publisher]
  }
  if publisher != "" and year != "" {
    body += [#year-sep]
  }
  if year != "" {
    body += [#year]
  }
  if pages != "" {
    if is-graduate {
      body += [: #pages. #entry.ref-label]
    } else {
      body += [. #pages. #entry.ref-label]
    }
  } else {
    body += [. #entry.ref-label]
  }
  body
}

#let render-custom-other(entry) = {
  let fields = entry.fields
  let lang = entry.lang
  let author = normalize-biblio-names(fields.at("author", default: fields.at("organization", default: "")), lang: lang)
  let title = fields.at("title", default: "")
  let publish-date = str(fields.at("date", default: fields.at("year", default: fields.at("issued", default: fields.at("updated", default: "")))))
  let cited-date = str(fields.at("urldate", default: fields.at("accessed", default: "")))
  let url = str(fields.at("url", default: fields.at("howpublished", default: "")))

  let body = []
  if author != "" {
    body += [#author. ]
  }
  if title != "" {
    body += [#title. ]
  }
  if publish-date != "" {
    body += [#publish-date]
    if cited-date != "" {
      body += [/#cited-date]
    }
    body += [. ]
  } else if cited-date != "" {
    body += [/#cited-date. ]
  }
  if url != "" {
    body += [#url. #entry.ref-label]
  } else {
    body += [#entry.ref-label]
  }
  body
}

#let render-custom-standard(entry) = {
  let fields = entry.fields
  let lang = entry.lang
  let drafter = normalize-biblio-names(fields.at("author", default: fields.at("organization", default: "")), lang: lang)
  let standard-number = str(fields.at("number", default: fields.at("serial-number", default: "")))
  let title = fields.at("title", default: "")
  let location = fields.at("location", default: fields.at("address", default: ""))
  let publisher = fields.at("publisher", default: fields.at("institution", default: ""))
  let year = str(fields.at("year", default: fields.at("date", default: "")))

  let body = []
  if drafter != "" {
    body += [#drafter. ]
  }
  if standard-number != "" and title != "" {
    body += [#(standard-number + "，" + str(title))]
  } else if standard-number != "" {
    body += [#standard-number]
  } else if title != "" {
    body += [#title]
  }
  if location == "" and publisher == "" and year == "" {
    body += [[S]. #entry.ref-label]
    return body
  }

  body += [[S]. ]
  if location != "" {
    body += [#location]
    if publisher != "" {
      body += [：]
    } else if year != "" {
      body += [，]
    } else {
      body += [. #entry.ref-label]
      return body
    }
  }
  if publisher != "" {
    body += [#publisher]
    if year != "" {
      body += [，]
    } else {
      body += [. #entry.ref-label]
      return body
    }
  }
  if year != "" {
    body += [#year. #entry.ref-label]
  } else {
    body += [#entry.ref-label]
  }
  body
}

#let bilingual-bibliography(
  bibliography: none,
  doctype: "master",
  twoside: false,
  english-writing: false,
  fonts: (:),
  leading: auto,
  spacing: auto,
  title: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  full: false,
  style: "gb-7714-2015-numeric",
  label-shift: 2.1em,
  label-gap: 0.5em,
  content-shift: -0.85em,
  content-hanging-indent: -4.3em,
  single-digit-content-hanging-indent: auto,
  double-digit-content-hanging-indent: -4.8em,
  triple-digit-content-hanging-indent: -5.2em,
  mapping: (:),
  extra-comma-before-et-al-trans: false,
  allow-comma-in-name: false,
) = {
  fonts = 字体 + fonts
  let is-graduate = doctype == "master" or doctype == "doctor"
  if title == auto {
    title = if english-writing { "References" } else { "参考文献" }
  }
  if title-leading == auto {
    title-leading = preface-heading-leading
  }
  if title-above == auto {
    title-above = if is-graduate { preface-heading-above } else { 0pt }
  }
  if title-below == auto {
    title-below = if is-graduate { preface-heading-below } else { 0pt }
  }
  if leading == auto {
    leading = if is-graduate { preface-body-leading } else { auto }
  }
  if spacing == auto {
    spacing = if is-graduate { preface-body-spacing } else { auto }
  }

  pagebreak(weak: true, to: if twoside { "odd" })

  set text(lang: "zh")
  set par(first-line-indent: preface-body-first-line-indent)

  if is-graduate {
    set text(font: fonts.宋体, size: 字号.小四)
    set par(leading: leading, spacing: spacing, justify: true, first-line-indent: preface-body-first-line-indent)
    show heading.where(level: 1, numbering: none): it => preface-heading-style(
      it,
      fonts,
      leading: title-leading,
      above: 0pt,
      below: title-below,
    )
    v(title-above)
    heading(level: 1, numbering: none, outlined: true)[#title]
  } else if title != none {
    heading(level: 1, numbering: none, outlined: true)[#title]
  }

  gb7714-bibliography(
    title: none,
    full: full,
    full-control: entries => {
      set par(hanging-indent: 2em, first-line-indent: 0em)
      for entry in entries {
        if entry.entry-type == "patent" {
          [[#entry.order]#h(0.5em)#render-custom-patent(entry)]
        } else if entry.entry-type == "inproceedings" or entry.entry-type == "conference" {
          [[#entry.order]#h(0.5em)#render-custom-conference(entry, doctype: doctype)]
        } else if is-custom-other-entry(entry) {
          [[#entry.order]#h(0.5em)#render-custom-other(entry)]
        } else if is-custom-standard-entry(entry) {
          [[#entry.order]#h(0.5em)#render-custom-standard(entry)]
        } else {
          [[#entry.order]#h(0.5em)#entry.labeled-rendered]
        }
        parbreak()
      }
    },
  )
}
