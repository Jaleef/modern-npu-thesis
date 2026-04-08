#import "../utils/datetime-display.typ": datetime-display, datetime-year-month
#import "../utils/style.typ": 字号, 字体

// 西北工业大学本科生封面
#let bachelor-cover(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stroke-width: 0.5pt,
  line-width: 5.5cm,
  title-line-width: 8cm,
  datetime-display: datetime-year-month,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: "基于 Typst 的西北工业大学毕业论文",
    author: "张三",
    major: "某专业",
    supervisor: ("李四", "教授"),
    submit-date: (year: 2026, month: 6),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  // 2.2 处理提交日期
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
      #text(font: fonts.宋体, size: label-size)[#label]
      #box(width: 0.2cm)
      #box(width: width)[
        #align(center + horizon)[
          #text(font: fonts.宋体, size: value-size)[#body]
        ]
        #line(length: 100%, stroke: stroke-width + black)
      ]
    ]
  }

  // 4.  正式渲染

  pagebreak(weak: true, to: if twoside { "odd" })

  // 居中对齐
  set align(center)

  // 匿名化处理去掉封面标识
  if anonymous {
    v(80pt)
  } else {
    v(2.3cm)
    image("../../template/images/nwpulogo.png", width: 10cm)
    v(1.3cm)
  }

  // 论文类型标题
  text(size: 字号.小初, font: fonts.宋体, weight: "bold")[本科毕业设计（论文）]

  if anonymous {
    v(180pt)
  } else {
    v(3.5cm)
  }

  block(width: 100%)[
    #underline-field("题　　目", mask-value((("",) + info.title).join(" ")), width: title-line-width, label-size: 字号.三号, value-size: 字号.三号)
    #v(1.5cm)
    #underline-field("专业名称", info.major)
    #v(1.1cm)
    #underline-field("学生姓名", mask-value(info.author))
    #v(1.1cm)
    #underline-field("指导教师", mask-value(info.supervisor.at(0)))
    #v(1.1cm)
    #underline-field("毕业时间", info.submit-date)
    #v(1fr)
  ]
}
