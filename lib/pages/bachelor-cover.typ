#import "../utils/style.typ": 字体, 字号
#import "../utils/cover-utils.typ": datetime-year-month, info-row, mask-value

// 本科生封面
#let bachelor-cover(
  anonymous: false,
  info: (:),
) = {
  info.submit-date = datetime-year-month(info.submit-date)

  v(72pt)
  image("../assets/nwpu-logo.png", width: 9cm)
  v(40pt)
  text(size: 字号.初号, weight: "bold")[本科毕业设计（论文）]
  v(150pt)
  text(font: 字体.黑体, size: 字号.三号, weight: "bold")[
    #table(
      columns: (2cm, 11cm),
      rows: 1.2cm,
      ..info-row(text()[题 目], [#info.title]),
    )
  ]
  text(size: 字号.四号)[
    #table(
      columns: (2.2cm, 6.5cm),
      rows: 2.3cm,
      ..info-row([专业名称], info.major),
      ..info-row([学生姓名], mask-value(info.author, anonymous: anonymous)),
      ..info-row([指导教师], mask-value(info.supervisor.at(0), anonymous: anonymous)),
      ..info-row([毕业时间], info.submit-date),
    )
  ]
}
