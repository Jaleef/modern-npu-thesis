#import "../utils/style.typ": 字体, 字号
#import "../utils/cover-utils.typ": datetime-year-month, info-row

// 本科生封面
#let bachelor-cover(
  anonymous: false,
  info: (:),
) = {
  info.submit-date = datetime-year-month(info.submit-date)

  let mask-value(body) = {
    if anonymous { "████████" } else { body }
  }

  v(2cm)
  image("../../template/figures/nwpulogo.png", width: 8cm)
  v(1cm)
  text(size: 字号.小初, weight: "bold")[本科毕业设计（论文）]
  v(5cm)
  text(size: 字号.三号, font: 字体.黑体)[
    #table(
      columns: (2cm, 10cm),
      rows: 1.2cm,
      ..info-row(text()[题 目], [#info.title]),
    )
  ]
  text(size: 字号.四号)[
    #table(
      columns: (2.2cm, 6cm),
      rows: 2.2cm,
      ..info-row([专业名称], info.major),
      ..info-row([学生姓名], mask-value(info.author)),
      ..info-row([指导教师], mask-value(info.supervisor.at(0))),
      ..info-row([毕业时间], info.submit-date),
    )
  ]
}
