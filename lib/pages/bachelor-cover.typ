#import "../utils/datetime-display.typ": datetime-display, datetime-year-month
#import "../utils/style.typ": 字号, 字体

// 西北工业大学本科生封面
#let bachelor-cover(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  info: (:),
  // 其他参数
  stroke-width: 0.5pt,
  line-width: 5.5cm,
  title-line-width: 8cm,
  datetime-display: datetime-year-month,
) = {
  // 参数处理
  // 处理提交日期
  // submit-date 支持 datetime 或 (year: 2026, month: 3) 格式
  if type(info.submit-date) == dictionary {
    info.submit-date = datetime(year: info.submit-date.year, month: info.submit-date.month, day: 1)
  }
  if type(info.submit-date) == datetime {
    info.submit-date = datetime-display(info.submit-date)
  }

  // 3.  内置辅助函数
  let mask-value(body) = {
    if anonymous { "████████" } else { body }
  }

  let underline-field(label, body, width: line-width, label-size: 字号.四号, value-size: 字号.四号) = {
    align(center)[
      #text(font: 字体.宋体, size: label-size)[#label]
      #box(width: 0.2cm)
      #box(width: width)[
        #set par(leading: 0em, spacing: 0em)
        #align(center)[
          #text(font: 字体.宋体, size: value-size, bottom-edge: "descender")[#body]
        ]
        #line(length: 100%, stroke: stroke-width + black)
      ]
    ]
  }

  // 4.  正式渲染

  // 居中对齐
  set align(center)

  // 匿名化处理去掉封面标识
  if anonymous {
    v(80pt)
  } else {
    v(2.3cm)
    image("../../template/figures/nwpulogo.png", width: 10cm)
    v(1.3cm)
  }

  // 论文类型标题
  text(size: 字号.小初, font: 字体.宋体, weight: "bold")[本科毕业设计（论文）]

  if anonymous {
    v(180pt)
  } else {
    v(3.5cm)
  }

  block(width: 100%)[
    #underline-field("题　　目", mask-value(info.title), width: title-line-width, label-size: 字号.三号, value-size: 字号.三号)
    #v(1.5cm)
    #underline-field("专业名称", info.major)
    #v(0.8cm)
    #underline-field("学生姓名", mask-value(info.author))
    #v(0.8cm)
    #underline-field("指导教师", mask-value(info.supervisor.at(0)))
    #v(0.8cm)
    #underline-field("毕业时间", info.submit-date)
    #v(1fr)
  ]
}
