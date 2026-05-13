#import "../utils/style.typ": 字体
#import "../deps.typ": zh
#import "../utils/cover-utils.typ": datetime-year-month, info-row, mask-value, half-space

// 本科生封面
#let bachelor-cover(
  anonymous: false,
  info: (:),
) = {
  if type(info.title) == str {
    info.title = (info.title,)
  }
  info.submit-date = datetime-year-month(info.submit-date)

  v(72pt)

  h(15pt)
  box(baseline: 11%, image("../assets/nwpu-logo.png", width: 1.64cm))
  h(26pt)
  box(image("../assets/nwpu-name.png", width: 6.25cm, height: 1.24cm))
  
  v(42pt)
  text(zh(0), weight: "bold")[本科毕业设计（论文）]
  v(140pt)
  let has-second-line = info.title.len() > 1 and info.title.at(1, default: "") != ""
  text(zh(3), font: 字体.黑体)[
    #table(
      columns: (2cm, 11cm),
      rows: if has-second-line { (1.2cm, 1.1cm) } else { (1.2cm,) },
      ..info-row(text(weight: "bold")[#half-space("题目")], [#info.title.at(0, default: "")]),
      ..if has-second-line {
        info-row([], [#info.title.at(1)])
      },
    )
  ]
  text(zh(4))[
    #table(
      columns: (2.2cm, 6.5cm),
      rows: 2.2cm,
      ..info-row([专业名称], info.major),
      ..info-row([学生姓名], mask-value(info.author, anonymous: anonymous)),
      ..info-row([指导教师], mask-value(info.supervisor.at(0), anonymous: anonymous)),
      ..info-row([毕业时间], info.submit-date),
    )
  ]
}
