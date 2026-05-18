#import "/template.typ": (
  Assign, IfElseChain, Return, While, algorithm, capfig, capsubfig, captab, multicite, nwpu-thesis, zh
)

#show: nwpu-thesis.with(
  anonymous: false, // 是否开启盲审模式
  info: (
    title: ("分布式键值存储系统的研究与实现"),
    major: "计算机科学与技术",
    author: "闫佳乐",
    supervisor: ("谷建华", "教授"),
    submit-date: (year: 2026, month: 6),
  ),
  abstract: (
    content: [
      随着互联网数据规模的爆发式增长，传统的单机键值存储系统在数据容量和读写吞吐量方面面临严峻的挑战，如果一昧的增加单机容量和性能，成本将呈现指数级增长。
      而分布式键值存储系统则通过数据分片和多节点部署有效解决了这一问题，但现有开源系统（如 Redis Cluster，TiKV）架构复杂、学习门槛高，不利于教学和研究使用。
      本文针对该应用场景，设计并实现了一个轻量级分布式键值存储系统LEKV。
      
      本文的主要工作内容包括:
      #enum(
        indent: 2em,    // 序号块左缩进
        body-indent: 0.5em, // 序号块内文本缩进
        [系统架构上，采用 Proxy + DataNode 双层架构，Proxy 负责请求路由和负载均衡，DataNode 负责数据存储和查询，简化了系统设计并提高了可维护性],
        [通信层面上，设计了一套自定义二进制通信协议，包含完整的帧格式定义、操作码规范和粘包处理机制，有效降低了网络传输开销],
        [存储层面上，系统集成了 LevelDB 作为底层存储引擎，实现了常规的 PUT / GET / DELETE 操作，并实现了 O(logN) 的范围查询与统计能力],
        [分片与负载均衡上，设计了自适应分片算法，支持动态调整分片数量和数据迁移，保证系统在节点增减时的高可用性和负载均衡],
      )

      该系统在小型集群环境下的优异表现，验证了设计的合理性和实现的有效性，为分布式键值存储系统的教学和研究提供了一个简洁易用的平台。
    ],
    keywords: ("分布式键值存储", "负载均衡", "LevelDB", "分片算法", "二进制通信协议"),
  ),
  abstract-en: (
    content: [
      With the explosive growth of internet data, traditional single-node key-value storage systems face severe challenges in terms of data capacity and read/write throughput.
      Simply increasing the capacity and performance of single nodes leads to exponential cost growth. Distributed key-value storage systems effectively address this issue through data sharding and multi-node deployment, 
      but existing open-source systems (e.g., Redis Cluster, TiKV) have complex architectures and high learning curves, 
      making them less suitable for teaching and research purposes. For this purpose, this paper designs and implements a lightweight distributed key-value storage system called LEKV.

      The main contributions of this paper include:
      #enum(
        indent: 2em,
        body-indent: 0.5em,
        [On the system architecture, I adopted a Proxy + DataNode dual-layer architecture, where the Proxy is responsible for request routing and load balancing, while DataNode is responsible for data storage and querying,
        simplifying the system design and improving maintainability],
        [On the communication layer, I designed a custom binary communication protocol, including a complete frame format definition, opcode specification, and sticky packet handling mechanism, effectively reducing network transmission overhead],
        [On the storage layer, the system integrates LevelDB as the underlying storage engine, implementing conventional PUT / GET / DELETE operations, and achieving O(logN) range query and statistical capabilities],
        [On sharding and load balancing, I designed an adaptive sharding algorithm that supports dynamic adjustment of shard count and data migration, ensuring high availability and load balancing when nodes are added or removed],
      )

      The excellent performance of the system in a small cluster environment validates the rationality of the design and the effectiveness of the implementation, providing a simple and easy-to-use platform for teaching and research on distributed key-value storage systems.
    ],
    keywords: ("Distributed Key-Value Storage", "Load Balancing", "LevelDB", "Sharding Algorithm", "Binary Communication Protocol"),
  ),
  appendix: [
    我的个人 github 链接: #link("https://github.com/Jaleef")

    我的项目 gitee 链接: #link("https://gitee.com/undergra-graduation_proj_2026/LeKV")
  ],
  acknowledgement: [
    在完成本论文的过程中，我得到了很多人的支持与帮助，在此我要表达我最诚挚的感谢。
    
    首先，我要感谢我的导师谷建华教授，感谢他在学术上的指导，在我实现该系统的过程中，谷教授一次又一次的给我指出系统设计方向上的问题；我因研究生复试而耽误了做毕业设计，谷教授也非常理解和支持我，帮助我顺利完成了毕业设计的工作。
    
    最后，我要感谢我的家人和朋友们，他们一直是我坚强的后盾，给予我无尽的支持和鼓励。
  ],
  design-summary: [
    这个毕业设计让我学到了很多知识。
    
    首先是开发一个项目的经验，从前做一个项目时，比如课程大作业，都是直接上手写代码，而这次开发一个分布式系统，必须先进行整体的设计，明确系统的架构、模块划分、接口定义等，这些都是之前没有经历过的。通过这个过程，我学会了如何从整体上把握一个项目，如何进行系统设计和规划。

    其次是分布式系统的相关知识，之前只在课程上接触过数据库、存储相关的知识，而这次毕业设计让我深入了解了专业的分布式系统的架构设计、通信协议、数据存储等方面的知识，尤其是分布式系统中的数据分片、负载均衡等问题，这些都是之前没有接触过的。

    这也是一次重要的实践机会，让我将理论、算法应用到实际的项目中，并锻炼了我的编程能力，对我产生了很深远的影响。
  ],
)

= 绪论
== 研究背景与意义
随着互联网数据规模的爆炸式增长，传统的单机存储系统在数据容量和读写吞吐率方面面临严峻的挑战。分布式键值存储系统通过数据分片和多节点部署有效解决了这一问题，成为大规模数据存储的主流方案。然而，现有开源系统（如 Redis Cluster，TiKV）架构复杂、学习门槛高，不利于教学和研究使用。因此，设计一个轻量级、易于理解和使用的分布式键值存储系统具有重要的研究意义。

== 国内外研究现状

== 本文主要工作
本文主要研究内容包括一下几个方面。

（1）系统架构的是我设计该系统时首先要考虑的，目前流行的架构有主备复制架构、数据分片架构和两者结合的架构，我经过设计目的和复杂度的考虑，选择了数据分片架构，也就是主节点负责将数据分片到不同的数据节点，数据节点负责具体的数据存储，这样层次分明的架构，有利于理解分布式的本质，并且利于我的实现，如此，我可以将工作内容聚焦到分布式中心内容，比如分片算法，如何将数据更有效的分到数据节点，比如负载均衡，让分布式中的每个节点均衡分布，这是分布式中主要需要解决的问题。

（2）通信也是分布式系统的核心，因为数据分布到了不同的节点，数据的交互就从单机系统内的进程通信变成了网络间的通信，因此设计一个符合该系统的高效的通信协议是系统性能的关键。我设计的通信协议包括了不同通信请求二进制通信帧的设计、通信操作码、错误码的规范和不同通信请求的交互过程。

（3）存储层面我选择了当前主流的基于 `LSM-Tree` 的存储引擎 `LevelDB`，我基于该引擎封装了系统需要的 `API` 如 PUT / GET / DELETE / RangeQuery / RangeStats，来给上层系统提供存储服务，该存储引擎是一种内存存储结合硬盘持久化存储双重方式，数据先存入内存的跳表（Skip List）中，不会占用太多的系统 IO，存储的速度相当快，当存储量超过一定阈值后，引擎将数据异步存入磁盘中持久化，这样也不会占用太多 CPU 时间，影响存储系统接收其他的请求。

（4）分布式的核心就是如何将数据分开存储，所以如何高效的将数据分到正确的节点，是分片算法的设计目标，当不同的数据节点存储不同的数据后不再平衡了，这也就需要负载均衡策略平衡不同节点的数据量，我给本系统设计的分片算法是自适应有序分片算法，一个 Tablet 负责一个逻辑上的数据范围，初始不同的数据节点分别有一个 Tablet，当存在 Tablet 的数据量超过一定阈值后，就会将其分裂成两个 Tablet，然后以 Tablet 为单位进行数据迁移，维护每个节点的负载均衡。 

== 论文组织结构
本位分为六个章节，具体内容如下：

第一章介绍了本系统的研究背景与意义，然后说明当前国内外研究的现状，再详细列出我的设计内容，为后续的章节做了铺垫。

第二章介绍了关键的理论基础和系统实现选择的算法，如分布式架构，分片算法等，以及我的用到的存储技术和通信协议的设计

第三章介绍了系统的在不同的需求与问题面前选择的设计方案，如系统总体架构的设计方案，通信协议的设计，分片路由与负载均衡策略。

第四章介绍了系统在 `Linux` 操作系统环境下，使用 `C++` 语言实现上面的设计，包括开发工具、网络通信模块、存储引擎模块和核心节点逻辑的实现。

第五章对系统进行了功能正确性测试和性能测试，验证系统的正确性和性能表现。

第六章总结全文的研究内容，并对后续的课题发展方向进行了展望。

= 关键理论与技术
== 分布式存储系统基础
=== CAP 定理与 BASE 理论
==== CAP 定理
2000年，加州大学伯克利分校的 Eric Brewer 提出 CAP 猜想，然后由 Seth Gilbert 和 Nancy Lynch 给出形式化证明。CAP 定理是分布式系统领域最重要的理论基础之一，它指出：


> 一个分布式系统不可能同时满足一致性（Consistency）、可用性（Availability）和分区容错性（Partition Tolerance）这三个基本需求，最多只能同时满足其中两个。

== 范围分片

== LevelDB 存储引擎

== 通信协议设计

= 系统设计

== 系统总体架构

== 通信协议设计

== 分片与路由机制

== 自动分裂策略

== 负载均衡策略

= 系统实现

== 开发环境与工具

== 网络通信模块实现

== 存储引擎模块实现

== 核心节点逻辑实现

== 关键数据结构

= 系统测试与分析

== 测试环境搭建

== 功能测试

== 性能测试

== 测试结果与分析

= 总结与展望

== 工作总结

== 不足与展望


= 图、表、公式、算法示例

== 图示例

=== 单张图

可以使用 `capfig()` 来创建图，支持图标题、标签等功能。如@test 所示。

#capfig(
  image("figures/example.jpg", width: 20%),
  caption: [图片测试],
  label: <test>,
)

=== 多张图

可以使用 `capsubfig()` 来创建多子图，支持子图标题、标签，以及总图标题和标签。下面是两列的两张图示例，以及两列的四张图示例。子图也可以直接引用，如@fig-sub1。

#capsubfig(
  (
    (content: image("figures/example.jpg", width: 40%), subcaption: [第一个子图说明], label: <fig-sub1>),
    (content: image("figures/example.jpg", width: 40%), subcaption: [第二个子图说明], label: <fig-sub2>),
  ),
  columns: 2,
  caption: [总图标题],
  label: <fig-main>,
)

#capsubfig(
  (
    (content: image("figures/example.jpg", width: 40%), subcaption: [第一个子图说明], label: <fig-sub3>),
    (content: image("figures/example.jpg", width: 40%), subcaption: [第二个子图说明], label: <fig-sub4>),
    (content: image("figures/example.jpg", width: 40%), subcaption: [第三个子图说明], label: <fig-sub5>),
    (content: image("figures/example.jpg", width: 40%), subcaption: [第四个子图说明], label: <fig-sub6>),
  ),
  columns: 2,
  caption: [总图标题],
  label: <fig-2x2>,
  placement: top,
)

== 表示例

=== 表

可以使用 `captab()` 来创建表格，支持表格标题、标签、列宽、横线等功能。下面是一个简单的表示例，@timing-tlt，以及一个复杂的表示例，@composite-performance。

可以使用 `placement` 参数来设置表格位置，支持 `none`、 `top`、`bottom` 和 `auto`。其中，`none` 是默认值，表示位于本来的位置；`auto` 只是 `top` 和 `bottom` 的简单增强版，会自动选择到顶部/底部。可以使用 `three-line-table` 参数来设置是否使用三线表风格。

#captab(
  caption: [表标题],
  label: <timing-tlt>,
  placement: top,
  three-line-table: true
)[
  | t   | 1    | 2    | 3    |
  | --- | ---- | ---- | ---- |
  | y   | 0.3s | 0.4s | 0.8s |
]

#captab(
  caption: [复杂表示例：聚合物基复合材料的性能],
  label: <composite-performance>,
)[
  | 材料           | 碳/环氧 | <    | 玻璃/环氧 | <    |
  | ^              | 纵向    | 横向 | 纵向      | 横向 |
  | 模量，GPa      | 181     | 10.3 | 38.6      | 8.3  |
]

=== 续表示例

可以通过 `breakable` 参数来设置表格是否允许分页，默认为 `false`。可以通过 `size` 参数来设置表格内文字的字号，默认为五号字体。

#captab(
  caption: [表标题],
  label: <timing>,
  breakable: true,
  size: zh(5.5),  // 手动设置为小五号
)[
  | t   | 1    | 2    | 3    |
  | --- | ---- | ---- | ---- |
  | a   | 0.3s | 0.4s | 0.8s |
  | b   | 0.3s | 0.4s | 0.8s |
  | c   | 0.3s | 0.4s | 0.8s |
  | d   | 0.3s | 0.4s | 0.8s |
  | e   | 0.3s | 0.4s | 0.8s |
  | f   | 0.3s | 0.4s | 0.8s |
]

== 公式示例

可以像 Markdown 一样写行内公式 $x + y$。

引用数学公式需要加上 `eqt:` 前缀，如@eqt:energy-mass。

$ E = m c^2 $ <energy-mass>

== 算法示例

下面给出采用单独算法编号的三线表风格算法示例，见@binary-search。

#algorithm(
  title: [二分查找算法],
  {
    Assign[left][$0$]
    Assign[right][len(A) - 1]
    While(
      [$"left" <= "right"$],
      {
        Assign[mid][$floor(("left" + "right") / 2)$]
        IfElseChain(
          [$A_"mid" = "target"$],
          { Return[mid] },
          [$A_"mid" < "target"$],
          { Assign[left][$"mid" + 1$] },
          { Assign[right][$"mid" - 1$] },
        )
      },
    )
    Return[$-1$]
  },
) <binary-search>

= 参考文献引用示例

可以像这样引用参考文献@周融2003，引用两个的文献 #multicite("伍蠡甫", "图书馆")，引用三个以上的文献 #multicite("张筑生", "gbt16159-1996", "冯西桥1998", "姜锡洲", "中国大学学报论文文摘", "DUBAR2013--", "FOURNEY")。
