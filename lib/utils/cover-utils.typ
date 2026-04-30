// 封面共享工具

// 信息行：标签 + 下划线值（用于封面表格）
#let info-row(label, value, stroke-width: 0.5pt) = (
  table.cell(align(bottom)[#label]),
  table.cell(stroke: (bottom: stroke-width), align(bottom)[#value]),
)

// 中文学术职称到英文的映射
#let title-en-map = (
  "教授": "Professor",
  "副教授": "Associate Professor",
  "研究员": "Researcher",
  "讲师": "Lecturer",
)

// 名字等宽处理：仅对中文短姓名生效，避免与英文长姓名混排时被过度拉伸
#let pad-name(name, target-len) = {
  if target-len > 4 {
    name
  } else {
    let clusters = name.clusters()
    let current-len = clusters.len()
    if current-len >= target-len {
      name
    } else {
      let spaces-needed = target-len - current-len
      let result = ()
      let gap-count = current-len - 1
      if gap-count == 0 {
        result.push(clusters.at(0))
        result.push("　" * spaces-needed)
      } else {
        let base-spaces = calc.floor(spaces-needed / gap-count)
        let extra-spaces = calc.rem(spaces-needed, gap-count)
        for i in range(current-len) {
          result.push(clusters.at(i))
          if i < gap-count {
            let spaces = base-spaces + (if i < extra-spaces { 1 } else { 0 })
            result.push("　" * spaces)
          }
        }
      }
      result.join("")
    }
  }
}

// 显示中文日期（无前导零）
#let datetime-display(date) = {
  str(date.year()) + " 年 " + str(date.month()) + " 月 " + str(date.day()) + " 日"
}

// 显示年月（无前导零）
#let datetime-year-month(date) = {
  str(date.year()) + " 年 " + str(date.month()) + " 月"
}

// 显示英文年月（如 March/2026）
#let datetime-year-month-en(date) = {
  let months = ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
  months.at(date.month() - 1) + "/" + str(date.year())
}
