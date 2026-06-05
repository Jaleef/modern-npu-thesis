#import "/template.typ": (
  Assign, IfElseChain, Return, While, algorithm, capfig, capsubfig, captab, multicite, nwpu-thesis, zh, 
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
        [系统架构上，采用主从架构，包括主节点 Master，负责请求路由和负载均衡；数据节点 DataNode，负责数据存储和查询，简化了系统设计并提高了可维护性],
        [通信层面上，设计了一套自定义二进制应用层通信协议，包含完整的帧格式定义、操作码规范和粘包处理机制，有效降低了网络传输开销],
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
        [On the system architecture, I adopted a Master + DataNode dual-layer architecture, where the Master is responsible for request routing and load balancing, while DataNode is responsible for data storage and querying,
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
随着互联网数据规模的爆炸式增长，传统的单机存储系统在数据容量和读写吞吐率方面面临严峻的挑战。分布式键值存储系统通过数据分片和多节点部署有效解决了这一问题，成为大规模数据存储的主流方案。然而，现有开源系统（如 Redis Cluster，TiKV）架构复杂、学习门槛高，不利于研究使用。因此，设计一个轻量级、易于理解和使用的分布式键值存储系统具有重要的研究意义。

== 国内外研究现状
=== 国外研究现状
分布式键值存储系统的研究起源于2000年代初期，伴随着互联网规模的快速扩张，学术界和工业界对海量数据的存储与访问提出了迫切需求。2006年，Google发表了关于Bigtable @chang2008bigtable ，系统性地阐述了基于范围分片（Range-based Sharding）的分布式结构化数据存储方案。Bigtable 将数据划分为Tablet，通过Tablet Server负责实际存储，Master负责负载均衡和元数据管理。Bigtable的设计深刻影响了后续的HBase @george2008hbase 、CockroachDB @taft2020cockroachdb 等开源系统，其范围分片策略为有序数据的高效范围查询奠定了基础。然而，Bigtable作为Google内部系统并未开源，其实现细节对外界不可见。

#capfig(
  image("figures/bigtable_arch.png", width: 75%),
  caption: [Bigtable 架构示意图]
)

在开源领域，Redis @sanfilippo2009redis 由Salvatore Sanfilippo于2009年开发，采用单线程事件循环模型，基于哈希表实现O(1)的键值读写，并支持字符串、列表、集合、有序集合等多种数据结构。Redis Cluster提供了分布式能力，采用哈希槽 @wang2023hashslot （Hash Slot）分片策略将16384个槽位均匀分配到多个节点，支持自动故障转移和在线扩缩容。然而，Redis Cluster的架构较为复杂，涉及Gossip协议通信 @kermarrec2007gossiping 、槽位迁移、ASK/MOVED重定向等机制，代码量超过20万行，对于教学研究和快速原型开发而言门槛过高。此外，Redis以内存存储为主，持久化能力相对有限（RDB快照 @li2018consistent 和AOF日志 @kim2018persistent ），在数据量超出内存容量时性能急剧下降。
#capfig(
  image("figures/RedisCluster_arch.drawio.png", width: 75%),
  caption: [Redis Cluster 架构示意图]
)

2013年，CoreOS团队发布了etcd @jeffery2023mutating ，一个基于Raft共识算法   @ongaro2014search 的高可用键值存储系统。etcd将Raft协议的Leader选举、日志复制和安全性证明完整地工程化实现，成为分布式系统领域学习共识算法的标杆项目。etcd采用Raft日志作为唯一的写入路径，所有数据变更都通过Leader节点同步到多数派Follower后才提交，提供了强一致性保证。然而，etcd的定位是配置存储和服务发现，其设计目标并非高吞吐的通用键值存储——单集群推荐的存储上限为8GB，且不支持数据分片，所有数据存储在每个节点上，无法通过增加节点来扩展存储容量。这使得etcd难以直接作为大规模数据存储的教学平台。

Amazon于2007年发表的Dynamo论文 @decandia2007dynamo 。Dynamo采用一致性哈希 @karger1997consistent （Consistent Hashing）进行数据分片，通过Gossip协议实现节点间的信息同步，并使用向量时钟 @fidge1988partial （Vector Clock）解决并发写冲突。Cassandra @lakshman2010cassandra 作为Dynamo模型的开源实现，继承了去中心化的对等架构（Peer-to-Peer），支持多数据中心部署和可调一致性级别（ONE/QUORUM/ALL）。然而，Cassandra的架构复杂度极高——涉及多种一致性级别选择、反熵修复 @demers1987epidemic （Anti-Entropy Repair）、Hinted Handoff、Read Repair等机制，理解和调试都需要深厚的分布式系统背景。

=== 国内研究现状
近年来，国内在分布式存储领域取得了显著进展。PingCAP公司开发的TiKV @wang2021rethink 是其中最具代表性的开源项目。TiKV采用Rust语言实现，作为TiDB分布式数据库的存储层，提供了完整的分布式事务支持和基于Raft的多副本一致性保证。TiKV将数据划分为Region（类似于Tablet），采用范围分片策略，支持Region的自动分裂与合并，并通过Placement Driver（PD）组件实现全局调度和负载均衡。TiKV的架构设计和工程实现达到了生产级水平，但其代码量超过30万行，涉及Rust异步编程、Raft状态机、MVCC事务、分布式调度等多个复杂模块，对于本科阶段的教学实践而言，阅读和修改的门槛过高。
#capfig(
image("figures/Tikv_arch.drawio.png", width: 100%),
  caption: [TiKV 架构示意图]
)

阿里云自研的PolarDB系列采用了计算存储分离 @cao2022cloudjump 的架构，底层使用PolarFS @cao2018polarfs 分布式文件系统支持MySQL和PostgreSQL的共享存储模式。虽然PolarDB主要定位为关系型数据库@codd1970relational ，但其底层存储引擎同样涉及分布式键值存储的核心技术，如日志结构化存储、多副本复制和一致性协议。PolarDB的架构高度优化于云环境，与特定硬件（RDMA网络@ziegler2020rdma、NVMe SSD@ren2025survey）深度绑定，难以在普通教学环境中部署和实验。

#capfig(
  image("figures/comparison.png", width: 100%),
  caption: [分布式键值存储系统对比]
)

== 本文主要工作
本文主要研究内容。

*第一点*：系统架构的是`LEKV`设计时最需要考虑的，当前常用的架构有主备复制架构 @oki1988viewstamped 、数据分片架构和两者结合的架构，出于设计目的和复杂度的考虑，就选择了数据分片架构，也就是主节点负责将数据分片到不同的数据节点，数据节点负责具体的数据存储，这样层次分明的架构，实现起来更简单与高效，就可以将工作内容集中到分布式的中心内容（分片算法，如何将数据更有效的分到数据节点；负载均衡，让分布式中的每个节点均衡分布）。

*第二点*：通信也是分布式系统的核心，因为数据分布到了不同的节点，数据的交互就从单机系统内的进程通信变成了网络间的通信，因此设计一个符合该系统的高效的通信协议是系统性能的关键，`LEKV` 的通信协议包括了不同通信请求二进制通信帧的设计、通信操作码、错误码的规范和不同通信请求的交互过程。

*第三点*：在存储层面`LEKV`选择了当前主流的基于 `LSM-Tree`  的存储引擎 `LevelDB`，基于该引擎封装了需要的 `API` 如 *PUT / GET / DELETE / RangeQuery / RangeStats*，来给上层系统提供存储服务，`LevelDB`是一种内存存储结合硬盘持久化存储双重方式，数据先存入内存的跳表@pugh1990skip （Skip List）中，不会占用太多的系统 IO，内存的读写速度相比磁盘也更高速，当存储量超过一定阈值后，引擎将数据异步存入磁盘中持久化，不占用太多 CPU 时间，影响存储系统接收其他的请求。

*第四点*：分布式的核心就是如何将数据分开存储，所以高效的将数据分到正确的节点就是分片算法的设计目标，当不同的数据节点存储不同的数据后不再平衡了，这也就需要负载均衡策略平衡不同节点的数据量，`LEKV`设计的分片算法是自适应有序分片算法，一个`Tablet`负责一个逻辑上的数据范围，初始不同的数据节点分别有一个`Tablet`，当存到`Tablet`里的数据数量超过一定阈值后，就会将其分裂成两个，然后以`Tablet`为单位进行数据迁移，维护每个节点的负载均衡。 

== 论文组织结构
本位分为六个章节，具体内容如下：

第一章介绍了本系统的研究背景与意义、国内外研究的现状与`LEKV`的设计内容。

第二章介绍了分布式关键的理论基础和使用的技术方案。

第三章介绍了`LEKV`的应用分析与总体设计。

第四章介绍了`LEKV`在 `Linux` 操作系统环境下，使用 `C++` 语言对各个模块的设计与实现。

第五章对系统进行了功能正确性测试和性能测试。

第六章总结全文的研究内容，并对后续的课题发展方向进行了展望。


= 关键理论与技术
== 分布式系统架构
分布式系统的组织架构决定了节点之间的协作方式、数据流转路径以及系统的可扩展性。根据节点之间是否存在中心化的协调者，分布式架构主要分为集中式架构和对等架构两大类。


=== 集中式架构的研究
集中式架构（Centralized Architecture）由一个或多个中心节点负责全局协调和元数据管理，其他工作节点负责执行具体的计算或存储任务。中心节点通常承担以下职责：维护全局元数据（如数据分布位置、节点存活状态），做出全局调度决策（如负载均衡、数据迁移），以及作为客户端接入系统的统一入口。

这种架构的优点是：逻辑清晰，所有决策由中心节点统一做出，易于理解和调试；调度高效，中心节点掌握全局信息，能够做出最优的资源分配决策；客户端简单，客户端只需知道中心节点地址即可接入系统，底层节点的动态变化对客户端透明。其缺点在于：中心节点可能成为单点故障源，若中心节点宕机则整个系统的协调功能不可用；中心节点可能成为性能瓶颈，当集群规模扩大时，中心节点需要维护大量的元数据和连接，负载较重。

在分布式存储领域，Google Bigtable 的 Master + Tablet Server 架构、TiKV 的 Placement Driver + TiKV Node 架构都属于集中式架构的典型代表。LEKV 同样采用了集中式架构设计——Master 作为中心节点负责路由管理和负载调度，DataNode 作为工作节点负责数据存储。



=== 对等架构的研究
对等架构（Peer-to-Peer Architecture，简称 P2P 架构）中所有节点地位平等，不存在中心化的协调节点。每个节点既承担数据存储职责，也参与系统的协调决策。节点之间通过 gossip 协议或其他对等通信机制交换状态信息，共同维护系统的全局视图。

P2P 架构的优点是：无单点故障，任意节点的宕机不会影响系统的整体可用性；天然负载均衡，数据和请求均匀分布在所有节点上，不存在中心节点的性能瓶颈；水平扩展性好，新节点加入只需与其他节点建立连接即可融入集群，无需向中心节点注册。其缺点是：协调复杂，在缺乏全局视图的情况下做出一致性决策需要复杂的协议支持；调试困难，由于状态分散在多个节点上，问题定位和系统监控较为困难。

Cassandra 和 Amazon Dynamo 是 P2P 架构的代表性系统，它们采用一致性哈希进行数据分片，通过 gossip 协议实现节点间的信息同步。LEKV 没有选择 P2P 架构，主要考虑到 P2P 架构涉及的一致性协议（如反熵修复、Hinted Handoff 等）实现复杂，不利于本课题以学习研究为目的的实现。



== 数据分片策略
数据分片（Data Sharding）是指将大规模数据集划分为多个较小的子集（或称为分片），分散存储在不同节点上，从而实现负载均衡和水平拓展。


=== 哈希分片的研究
哈希分片（Hash-based Sharding），是指通过对 key 计算哈希值，再根据数据节点的个数取模来确定数据的存储位置。
 ```cpp
node = hash(key) % N  // N 是数据节点的数量
 ```

*优点*是数据分布均匀，哈希函数的随机性天然打散热点数据；实现简单，路由计算速度快O(1)；无需维护全局路由表，每个节点独立计算数据位置。

但是缺点也很明显：
（1）范围查询时即使是相邻的数据也可能哈希到完全不同的节点，范围查询需要访问所有的节点；（2）当节点增减时，哈希函数的输出会发生大规模变化，导致频繁的数据迁移；（3）不支持数据局部性，无法利用数据访问的局部性原理优化性能。

因此，`LEKV`放弃哈希分片，而是选择一种有序的范围分片方案。

=== 范围分片的研究
范围分片（Range-based Sharding），是将 key 的完整有序空间划分为若干个连续的区间（Range），每个区间分配到一个节点上：
```cpp
初始情况下
节点1：["", "m")    // 一个 Tablet，内部key <= "m"
节点2：["m", "")    // 一个 Tablet，内部key >= "m"
```

*优点*是：（1）范围查询相邻的`key`存储在同一节点上，范围查询只需要访问相关的数据节点；（2）节点增加节点时只需迁移部分区间，不影响其他区间的数据；（3）节点内的数据是有序的，可以高效地进行范围查询和统计；（4）负载均衡以`Tablet`为单位迁移，无需迁移单个 key。

*缺点*是需要维护全局路由表，`Master`需要知道每个节点负责的`key`范围，路由表的更新会占用系统资源；需要额外的分裂机制，处理一个`Tablet`数据量过大时的情况；

`LEKV`的设计选择为范围分片策略，原因有：（1）系统基于 LevelDB 存储引擎构建，它的 LSM-Tree 结构天然保证 key 有序，范围分片可以充分利用这一特性实现高效的范围查询；（2）范围分片以 Tablet 为单位，是独立可迁移的单元，便于实现自动分裂和负载均衡；（3）即使需要维护全局路由表，但可以通过缓存机制减少路由查询，并且路由表的更新频率相对较低，系统性能影响可控。



== LevelDB 存储引擎
在分布式键值存储系统中，底层存储引擎的选择直接决定了系统的读写性能、数据持久化能力以及范围查询效率。


=== B+ 树的研究
传统关系型数据库普遍采用基于`B+`树@bayer1972organization 的存储结构，`B+`树是一种自平衡的多路搜索树，是`B树` @bayer1972organization 的变体。其*核心特点*有：（1）所有数据存储在叶子节点，内部节点只存储键值和指向子节点的指针，不存储实际数据；（2）叶子节点形成有序链表，通过指针相连；（3）每个节点可以有多个子节点，树高度较低。（4）节点大小匹配磁盘页（如4KB）。

#capfig(
  image("figures/B+Tree.png", width: 100%),
  caption: [B+ 树演示]
)

以上特点使得 B+ 树非常适合磁盘存储，能够高效地进行随机读写和范围查询。然而，B+ 树在写入性能方面存在瓶颈，因为每次插入或删除操作都可能导致节点分裂或合并，进而引发大量的磁盘 I/O 操作，尤其在 SSD 环境下会加速硬件磨损。为了获得更高的吞吐量和更简单的持久化机制，LEKV 系统采用 Google 开源的 LevelDB 作为底层存储引擎。LevelDB 基于 LSM-Tree（Log-Structured Merge-Tree）结构，将随机写转换为顺序写，同时具备键的天然有序性，为范围分片提供了坚实的底层支持。



=== LSM-Tree的研究
`LSM-Tree`@oneil1996lsm 是一种专门为写密集场景优化的数据结构，核心思想可以概括为"*延迟合并、顺序写入*"，与传统的`B+`树就地更新不同，它将所有对数据的写入操作转化为顺序追加操作。

LSM-Tree数据结构分为内存和磁盘两个层次，内存层次维护一个有序的数据结构`MemTable`，所有新写入的数据首先进入`MemTable`，当它达到预设大小阈值后，被标记为`Immutable MemTable`（只读），同时新的 `MemTable`被创建以继续接收写入。后台线程负责将`Immutable MemTable`顺序刷写到磁盘，生成不可变的`SSTable`（Sorted String Table）文件。磁盘上的`SSTable`按照生成时间组织成多个层级（Level-0 到 Level-N），层级越深的 SSTable 文件越大、数据越旧。


这种分层结构的关键特性是*越新的数据越靠近上层查询时需要从上往下逐层搜索*。为了控制读放大（Read Amplification），后台 Compaction 线程会定期将相邻层级的 SSTable 进行合并，清理被删除或覆盖的旧数据，同时保证每一层的数据总量符合容量限制。

#capfig(
  image("figures/LSM-Tree.png", width: 100%),
  caption: [LSM-Tree 演示]
)

LevelDB 的持久化写路径包含三个关键步骤：

*第一步：WAL （Write-Ahead Log）写入*，当用户调用 Put(key, value) 时，LevelDB 首先将操作追加到预写日志文件中，WAL 是一个纯追加的日志文件，所有写入都是顺序的，当 WAL 通过 fsync 刷盘后，LevelDB 会向调用方返回成功。

*第二步：MemTable 插入*，在 WAL 写入完成后，键值对被插入到内存中的 MemTable，LevelDB 的 MemTable 基于跳表（Skip List）实现，并驻留在内存中， insertion、查找和删除的时间复杂度均为 O(log N)。

*第三步：Immutable MemTable 与 SSTable 刷盘*，当 MemTable 的大小达到阈值（默认 4 MB）时，它被冻结为 Immutable MemTable，新的写入切换到新的 MemTable，后台线程将 Immutable MemTable 顺序写入磁盘，生成一个 Level-0 SSTable。

#capfig(
  image("figures/LSMTree_write.drawio.png", width: 100%),
  caption: [LevelDB 写路径示意图]
)

*读路径*则是一个从上至下的搜索过程：首先查找活跃的 MemTable，其次查找 Immutable MemTable（如果存在），然后按时间从新到旧依次查找各级 SSTable。为了加速读操作，LevelDB 为每个 SSTable 文件维护了布隆过滤器 @bloom1970space（Bloom Filter），可以快速判断某个键是否可能存在于该文件中。

#capfig(
  image("figures/LSMTree_read.drawio.png", height: 60%),
  caption: [LevelDB 读路径示意图]
)

LevelDB 提供了一套简洁的 C++ API，包括 PUT，GET，DELETE以及 WriteBatch（批量写入）和 Iterator（迭代器）等接口，`LEKV`利用 LevelDB 的这些底层支持实现了数据存储引擎。同时 LevelDB 存储键的天然有序有序性和范围迭代能力，支持了本系统的范围分片策略。



== 负载均衡理论
负载均衡（Load Balancing）是分布式系统中确保各节点资源利用率趋于均匀的核心机制。在分布式键值存储系统中，负载均衡的主要目标是将数据均匀分布在各个节点上，避免部分节点过载而其他节点空闲的情况。


=== 负载均衡基本策略的研究
负载均衡策略通常可以分为静态策略和动态策略两大类。

静态负载均衡策略在系统初始化时确定数据分布，运行期间不进行调整。例如基于哈希的分片策略就是一种静态策略——数据的分布位置在写入时就已经确定。静态策略实现简单、开销小，但无法适应运行时负载的变化。

动态负载均衡策略则根据系统运行时的负载信息，主动调整数据在各节点之间的分布。动态策略通常包含三个核心环节：负载信息收集（周期性统计各节点的数据量、请求量等指标）、负载差异判定（计算各节点负载之间的差距，判断是否需要调整）和负载迁移执行（将数据从过载节点迁移到低负载节点）。

LEKV 采用了动态负载均衡策略。Master 周期性地向各 DataNode 收集 Tablet 的 key_count 统计信息，计算各节点的总负载，当负载最高节点与最低节点的键数量差值超过 BALANCE_DIFF_THRESHOLD 时，触发 Tablet 迁移操作。



=== 分布式场景下负载迁移的研究
在分布式存储系统中，负载迁移涉及真实的数据搬迁，需要解决两个关键问题：数据一致性和迁移效率。

数据一致性方面，迁移过程中需要保证：（1）源节点在迁移期间仍能正常处理对该 Tablet 的读写请求；（2）迁移完成后，所有后续请求应路由到目标节点；（3）客户端持有的旧路由缓存应能平滑过渡到新路由。LEKV 通过"Scan + Transfer"机制实现数据迁移——Master 先从源节点读取指定范围内的全部键值对，然后逐条写入目标节点，最后原子更新路由表。对于客户端缓存不一致的问题，系统通过 ST_NOT_MY_SHARD 错误码通知客户端刷新路由表，保证最终一致性。

迁移效率方面，影响迁移速度的主要因素包括：网络带宽、数据序列化/反序列化开销以及目标节点的写入吞吐量。LEKV 在迁移过程中采用逐条同步写入的方式，虽然牺牲了一定的传输效率，但保证了每条数据都被目标节点正确接收和持久化，简化了迁移失败时的重试逻辑。


== 本章小结
本章系统介绍了分布式键值存储系统的核心理论与技术基础。首先对比分析了集中式架构与对等架构的优缺点，明确了 LEKV 采用集中式架构的设计依据；然后对比分析了哈希分片和范围分片两种数据分布策略，阐明了范围分片在有序存储、范围查询和负载均衡方面的优势；接着深入剖析了 LevelDB 存储引擎的 LSM-Tree 结构、读写路径和持久化机制，说明了其作为底层存储引擎的合理性；最后介绍了负载均衡的基本策略和分布式场景下的数据迁移问题，明确了 LEKV 设计的动态负载均衡机制和迁移流程。通过本章的理论分析，为后续系统设计与实现提供了坚实的理论基础。


= 系统应用分析与总体设计
== 应用场景分析
LEKV 面向研究学习场景，而非工业级生产环境。现有开源系统（Redis Cluster 20万+行代码、TiKV 30万+行 Rust 代码、Cassandra 复杂的 P2P 机制）虽然功能完备，但架构复杂、学习门槛高，不利于本科阶段的学习实验。LEKV 的定位是提供一个核心代码约3000行、架构清晰、单机可部署的轻量级平台，让学习者能快速掌握分布式存储的分片、路由、负载均衡等核心机制。

系统采用Master + DataNode 集中式架构，运行于 Ubuntu 22.04 环境下，支持单机多进程模拟分布式部署，也可扩展至多机局域网环境。


== 系统需求
LEKV 需要满足以下*功能需求*：
#captab(
  caption: [LEKV 系统需求分析],
  placement: none,
  width: 100%,
)[
| 需求项       | 说明                             |
| --------    | ------------------------------ |
| 基本 KV 操作 | 支持 PUT / GET / DELETE          |
| 范围查询     | 基于 LevelDB 有序性实现区间扫描与统计        |
| 自动分片     | Tablet 数据量超阈值时自动分裂             |
| 负载均衡     | 节点间数据不均衡时自动迁移 Tablet           |
| 路由缓存     | 客户端缓存路由表，减少 Master 查询压力         |
]

*非功能需求*：轻量级（核心代码 < 5000 行）、易部署（单 Linux 环境即可运行）、可扩展（模块化设计，算法可替换）、高性能（自定义二进制协议）、最终一致性。


== 系统层次设计
LEKV 采用 Master + DataNode 双层架构，包含三种角色：

Master（节点端口 9001） —— 中心协调节点：维护全局 Tablet 路由表；响应客户端路由查询；运行 BalancerLoop 后台线程执行分裂与均衡。

DataNode（端口自动分配） —— 数据存储节点：运行 LevelDB 实例处理读写请求；响应 Tablet 统计和数据迁移扫描。

客户端（lekv_cli） —— 用户交互入口：启动时拉取全量路由表缓存本地；根据缓存直接定位 DataNode 执行操作；遇 ST_NOT_MY_SHARD 时自动刷新缓存重试。

#capfig(
  image("figures/LEKV_arch.drawio.png", width: 100%),
  caption: [系统架构拓扑图]
)

系统按功能划分为四个模块：
#captab(
  caption: [LEKV 模块划分],
  placement: none,
  width: 100%,
)[
| 模块       | 职责                                         | 对应目录    |
| -----      | -----------------------------                | ---------- |
| 网络通信层 | TCP 服务端/客户端、二进制协议编解码、粘包处理   | `rpc/`     |
| 存储引擎层 | LevelDB 封装，提供线程安全的 KV 操作和范围查询  | `storage/` |
| 核心节点层 | Master/DataNode 业务逻辑、路由、分裂、均衡     | `kv/`      |
| 客户端   | 命令行工具，路由缓存管理，用户交互逻辑         | `lekv_cli.cpp`   |

]

通信协议采用自定义二进制帧格式：4B FrameLen + 1B Magic + 1B Version + 4B RequestID + 变长 Payload，通过长度前缀法解决 TCP 粘包。操作码覆盖路由查询（OP_GET_ROUTE / OP_SHARDS）、数据操作（OP_PUT / OP_GET / OP_DELETE）和内部管理（OP_TABLET_STATS / OP_SCAN_RANGE）三类。

数据分布采用范围分片：初始按 ASCII 字母表均分，Tablet 超载时自动以中位数为界分裂，通过 Scan + Transfer 机制完成节点间数据迁移。路由定位采用二分查找（O(log N)），客户端缓存路由表并通过 ST_NOT_MY_SHARD 机制实现最终一致性。


== 本章小结
本章从学习研究的应用场景出发，明确了 LEKV 的功能需求与非功能需求，选定了 Master + DataNode 集中式双层架构，划分了四个功能模块，设计了自定义二进制通信协议的高层次框架，以及基于范围分片的数据分布与路由方案。上述总体设计为后续章节的详细策略研究与代码实现提供了技术蓝图。


= 系统的设计与实现
== 开发进度管理
=== 开发流程
LEKV 的开发流程采用迭代式增量开发方法，分为以下几个阶段：
+ *需求分析与设计*：在项目初期，进行了系统需求分析和总体设计，明确了系统的架构、模块划分、通信协议和核心算法等关键技术方案，但这不是一成不变的，在后续的开发中会不断调整和完善，比如刚开始设计的架构为主备复制架构，而后面重构成了范围分片架构，通信协议也从文本协议调整为二进制协议。
+ *核心功能开发*：将每个开发周期定为1到2周，每个周期内集中开发一个或几个核心功能模块，比方说通信协议实现、路由机制、分裂策略等，每个周期结束时完成周报，总结本周期的每天的开发内容、遇到的挑战和解决方案，并规划下一个周期的开发任务。

=== 完成情况
系统开发的目标是设计一个高可用的研究性质的分布式键值存储系统，重点在于实现核心的分片机制、路由机制、自动分裂和负载均衡功能。截止目前，系统的核心功能模块已经基本完成，包括：
- Master 和 DataNode 的基本框架搭建完成，能够启动并监听对应的端口。
- 自定义二进制通信协议的实现完成，能够正确解析和构造通信帧。
- 基于范围分片的路由机制实现完成，客户端能够通过 Master 获取路由信息并直接与 DataNode 通信。
- Tablet 的自动分裂功能实现完成，能够根据键值数量自动分裂 Tablet 并更新路由表。
- 基于差值比较的负载均衡功能实现完成，能够定期统计节点负载并执行数据迁移以平衡负载。
- 存储引擎模块基于 LevelDB 的封装实现完成，能够执行基本的键值读写操作。

虽然核心功能已经实现，但系统仍处于初始版本阶段，存在一些已知的不足和待完善的功能，如分裂和负载均衡的触发条件需要进一步调整以适应不同的数据分布和负载情况；客户端缓存失效刷新机制需要优化以减少不必要的路由查询；系统的容错性和稳定性需要通过更多的测试和优化来提升。

== 开发环境与工具
=== 硬件与操作系统
开发机器是在我的个人笔记本电脑上进行的，具体配置如下：
#captab(
  caption: [开发环境配置],
  placement: none,
)[
| 设备名称 | 配置 |
| --- | --- |
| CPU | 11th Gen Intel(R) Core(TM) i5-11260H @ 2.60GHz |
| 内存 | 16 GB |
| WSL 分配资源 | 4 CPU cores, 8GB 内存，2GB Swap空间 | 
]

LEKV 系统的开发环境为 x86_64 架构的 Windows 11 操作系统里的 WSL@KochbergerTS19 （windows subsystem for linux） ，安装的具体 Linux 发行版为 Ubuntu 22.04 LTS。WSL 提供了一个兼容的 Linux 环境，使得开发者能够在 Windows 上使用 Linux 的工具链和库，同时享受 Windows 的便利性。Ubuntu 22.04 LTS 是一个长期支持版本，提供了稳定的开发环境和丰富的软件包，适合进行系统级软件的开发和测试。

=== 开发语言编译工具
系统采用 C++ 17 标准开发，主要基于一下考虑：
- C++提供对底层系统资源的直接访问能力，能够支持本系统高性能的二进制网络通信协议的实现；
- 同时 C++ 的丰富库生态（如 LevelDB），提供了较为简明的方式调用所需的外部库；
- 成熟的编译工具链（如 g++）使得开发效率得到保障；
- C++ 17 标准引入了许多现代化的语言特性，如std::optional、std::shared_ptr等，能够简化代码逻辑，提高可读性和安全性。

编译工具链选用 GCC / G++ 11.4.0 和 CMake 3.22.1。CMake 通过嵌套的 CMakeLists.txt 管理多模块构建，最终生成 lekv（服务端）和 lekv_cli（客户端）两个可执行文件。

=== 第三方依赖库
系统唯一的第三方依赖是 `Google LevelDB 1.23`。考虑到不同的环境和系统包管理的差异，LevelDB 以源码形式集成在项目的 third_party/leveldb/ 目录下，通过 storage/CMakeLists.txt 手动编译为静态库后链接到 storage 模块。这种方式避免了对外部包管理器（apt、vcpkg 等）的依赖，保证了项目在不同 Linux 发行版上的可移植性。

系统也依赖 Linux 的网络通信库@galluscio2022survey ，如 `<sys/socket.h>`、`<netinet/in.h>` 和 `<arpa/inet.h>` 等，用于实现 TCP 套接字通信。这一点也是系统只能在 Linux 环境下编译和运行的原因之一。

=== 代码结构与模块划分
项目的源代码组织如下
```
LEKV/
├── CMakeLists.txt              # 根构建配置
├── src/
│   ├── CMakeLists.txt          # 子目录聚合
│   ├── lekv.cpp                # 服务端主入口
│   ├── lekv_cli.cpp            # 客户端主入口
│   ├── storage/
│   │   ├── CMakeLists.txt      # LevelDB 编译 + storage 库
│   │   ├── storage_engine.h    # 存储引擎接口
│   │   └── storage_engine.cpp  # LevelDB 封装实现
│   ├── rpc/
│   │   ├── rpc_server.h/.cpp   # TCP 服务器
│   │   ├── rpc_client.h/.cpp   # TCP 客户端
│   │   ├── text_protocol.h/.cpp# 文本协议
│   │   └── binary_protocol.h/.cpp # 二进制协议
│   └── kv/
│       ├── CMakeLists.txt      # raftnode 库
│       ├── raft_types.h        # 数据结构定义
│       ├── raft_node.h         # 核心节点接口
│       └── raft_node.cpp       # Master/DataNode 逻辑
└── third_party/
    └── leveldb/                # LevelDB 1.23 源码
```

== 网络通信模块
=== 应用层通信协议设计
通信协议是分布式节点间交流的基础，HTTP @fielding1999http 等文本协议，虽然可读性强、调试方便，但是由于其文本格式的特性，存在较大的网络开销和解析开销，不适合高性能分布式系统的需求；JSON @bray2017json 等格式化文本协议，存在大量的序列化与发序列化过程，设计大量字符串解析和动态内存分配，会占用额外的网络带宽，并且解析过程 CPU 开销较大，尤其在高并发场景下会成为性能瓶颈。



=== 自定义二进制帧格式
LEKV 通信协议采用定长头部 + 可变长负载的二进制帧结构。帧格式如下
#captab(
  caption: [LEKV 通信帧的通用帧头格式],
  placement: none,
  width: 100%,
)[
| 字段      | 偏移 | 长度（Byte）| 字节序  | 说明 |
| ---       | ---  | ---        | ---    | --- |
| FrameLen  | 0    | 4          | 网络序 | 完整帧的字节数（包含自身的4B）|
| Magic     | 4    | 1          | -      | 固定值0x4C（ASCII 'L'）合法性校验 |
| Version   | 5    | 1          | -      | 协议版本号，当前为0x01 |
| RequestID | 6    | 4          | 网络序 | 请求标识，响应中原样返回 |
| Payload   | 10   | 变长       | -      | 内容负载，格式由操作码定义 |
]

FrameLen 发送时转换为网络字节序（大端），接收方读取后转换为本地字节序，即可计算出后续需要读取的字节数。Magic 字段用于快速校验帧的合法性，Version 字段支持协议的版本迭代和兼容性处理。RequestID 用来匹配请求与响应，在异步通信场景下使用。Payload 的格式根据不同的操作码（OP_CODE）定义，包含了具体的请求参数或响应数据。



=== 操作码与帧定义
Payload 的第一个字节为操作码（Operation Code），用于区分不同类型的请求和响应。LEKV 定义了七类操作码：
#captab(
  caption: [LEKV 操作码定义],
  placement: none,
  width: 100%,
)[
  | 操作码 | 宏定义 | 发起方 | 处理方 | 用途 |
  | ---  | --- | --- | --- | --- |
  | 0x01 | OP_GET_ROUTE | 客户端 | Master | 获取特定 key 的路由信息 |
  | 0x02 | OP_GET | 客户端 | DataNode | 获取 key 的值 |
  | 0x03 | OP_PUT | 客户端 | DataNode | 设置 key 的值 |
  | 0x04 | OP_DELETE | 客户端 | DataNode | 删除 key |
  | 0x05 | OP_PING | - | - | 预留 |
  | 0x06 | OP_SHARDS | 客户端 | Master | 获取当前所有 Tablet 的路由信息 |
  | 0x07 | OP_TABLET_STATS | Master | DataNode | 获取指定区间的统计信息 |
  | 0x08 | OP_SCAN_RANGE | Master | DataNode | 获取指定范围内的所有键值对 |
]

- 路由查询码（OP_GET_ROUTE）：客户端向 Master 发送该请求以获取特定 key 的路由信息。
#captab(
  caption: [OP_GET_ROUTE 请求 Payload 格式],
  placement: none,
  width: 100%,
)[
  | *1 B* Opcode | *2 B* KeyLen | *KeyLen B* key |
]

#captab(
  caption: [OP_GET_ROUTE 请求的响应帧],
  placement: none,
  width: 100%,
)[
  | *1 B* Status | *4 B* ValueLen | *1 B* TabletID | *4 B* Epoch | *2 B* RouteLen | *RouteLen B* RouteInfo |
]

ValueLen 表示响应帧的 payload 中 除了状态码以外的字节数。

- 数据操作码（OP_PUT / OP_GET / OP_DELETE）：客户端向 DataNode 发送该请求以执行对应的键值操作。
#captab(
  caption: [OP_PUT / OP_GET / OP_DELETE 请求 Payload 格式],
  placement: none,
  width: 100%,
)[
  | *1 B* Opcode | *2 B* KeyLen | *4 B* ValueLen | *KeyLen B* key | *ValueLen B* value |
]

#captab(
  caption: [OP_PUT / OP_GET / OP_DELETE 请求的响应帧],
  placement: none,
  width: 100%,
)[
  | *1 B* Status | *4 B* ValueLen | *ValueLen B* value |
]


- 路由表查询码（OP_SHARDS）：客户端向 Master 发送该请求以获取当前所有 Tablet 的路由信息，供客户端缓存使用。
#captab(
  caption: [OP_SHARDS 请求 Payload 格式],
  placement: none,
  width: 100%,
)[
  | *1 B* Opcode | *2 B* KeyLen = 0 | *4 B* ValueLen = 0 |
]

#captab(
  caption: [OP_SHARDS 请求的响应帧],
  placement: none,
  width: 100%,
)[
  | *1 B* Status | *4 B* ValueLen | *ValueLen B* RouteInfos |
]


- 数据统计码（OP_TABLET_STATS）：Master 向 DataNode 发送该请求以获取指定 Tablet 的统计信息。
#captab(
  caption: [OP_TABLET_STATS 请求 Payload 格式],
  placement: none,
  width: 100%,
)[
  | *1 B* Opcode | *2 B* StartLen | *StartLen B* start_key | *2 B* EndLen | *EndLen B* end_key |
]
#captab(
  caption: [OP_TABLET_STATS 请求的响应帧],
  placement: none,
  width: 100%,
)[
  | *1 B* Status | *4 B* ValueLen | *4 B* KeyCount | *2 B* MedianKeyLen | *MedianKeyLen B* MedianKey |
]

- 数据迁移码（OP_SCAN_RANGE）：Master 向 DataNode 发送该请求以获取指定范围内的所有键值对，用于分片迁移。
#captab(
  caption: [OP_SCAN_RANGE 请求 Payload 格式],
  placement: none,
  width: 100%,
)[
  | *1 B* Opcode | *2 B* StartLen | *StartLen B* start_key | *2 B* EndLen | *EndLen B* end_key |
]
#captab(
  caption: [OP_SCAN_RANGE 请求的响应帧],
  placement: none,
  width: 100%,
)[
  | *1 B* Status | *4 B* ValueLen | *4 B* Count | count \* (2B KeyLen + key + 4B ValueLen + value) |
]

以上就是所有的帧格式定义，以上这些二进制帧的优点在于紧凑和可快速解析，所有的数值字段都直接以原始二进制形式存储，接收方通过`reinterpret_cast`和字节序转换即可读取，无需字符串解析。以`OP_GET` 为例，一个key有8B，value有100B的请求，帧长仅为125B；而同样使用Http协议，帧长可能达到300B以上，且解析过程需要额外的 CPU 时间和内存分配。



=== 粘包问题 @dong2017solving 的产生与解决方案
TCP 协议 @eddy2022tcp 是面向字节流的传输层协议，只保证字节的有序性和可靠性，不保留应用层的消息边界。这意味着发送方两次 `send` 操作的数据，在接收方可能合并为一次 `recv` 返回；也可能由于网络拥塞，一次 `send` 的数据被拆分为多次 `recv` 到达。如果应用层简单地固定缓冲区大小（如每次读 1024 字节）进行读取，极有可能发生以下两种错误：
- *粘包（Frame Concatenation）*：接收缓冲区包含前一个帧的后半部分和下一个帧的前半部分，导致无法正确解析出一个有效的帧。
- * 半包（Partial Frame）*：接收缓冲区只包含了一个帧的前一部分，无法完整解析出一个有效的帧。

LEKV 采用长度前缀法（Length-Prefixed Framing）彻底解决粘包问题。其核心策略是：接收方维护一个动态增长的接收缓冲区，每次 `recv` 将新数据追加到缓冲区末尾，然后按照以下尝试提取完整帧：
+ 检查缓冲区中是否有至少 4 字节。若没有，阻塞等待下一次`recv`。
+ 读取前 4 字节，转换为整数得到 FrameLen，表示完整帧的字节数。
+ 检查缓冲区中是否有至少 FrameLen 字节。若没有，继续阻塞等待下一次`recv`。
+ 一旦缓冲区中有足够的字节，提取 FrameLen 字节作为一个完整帧，交付上层的 TryDecode 解析
+ 将缓冲区头部截断，保留剩余字节继续下一轮的帧解析。

这一机制的实现关键在于*不依赖固定缓冲区大小，而是以帧为单位读取数据*。读取函数内部会循环调用`recv`，每次将新到达的数据追加到缓冲区尾部，然后检查是否能提取完整帧。即使一次`recv`接收了多个完整的帧，第一个帧会被立即解析并返回给调用方，剩余的帧在缓冲区等待下一次读取；反之，如果一次`recv`只接收了一个帧的一部分，读取函数会继续调用`recv`直到完整帧到达为止。



=== 二进制编码与解码的实现要点
*编码流程（发送方）*：业务层根据操作类型构造 Payload 字节数组，然后调用 EncodeCustomRequest 或 EncodeResponse 封装帧头。EncodeResponse 的实现需要特别注意：它负责将 [Status][val_len][value] 拼接后计算总长度，生成包含 Magic、Version、RequestID 的完整帧，所有数值字段在写入前都通过 htonl/htons 转换为网络字节序。

*解码流程（接收方）*：读取函数首先按照前述的粘包处理机制提取完整帧，然后调用 TryDecode 解析帧头和 Payload。TryDecode 的实现需要严格按照帧格式定义解析各个字段，尤其要注意 Payload 中的可变长度部分（如 key 和 value）。对于数值字段，解码时需要通过 ntohl/ntohs 转换回主机字节序。解码过程中还需要进行 Magic 字段是否正确、Payload 长度是否匹配的合法性校验。



=== 应用层二进制协议帧的实现
BinaryProtocol 类提供了静态方案方法 EncodeRequest、EncodeCustomRequest 和 EncodeResponse，用于将业务逻辑中的请求和响应数据打包成符合协议格式的二进制帧。

- *EncodeRequest* 接受一个 Opcode、Key、Value，自动构造通用帧头
```
创建字节数组 buf
为 buf 预留 frame_len 大小的空间

将 frame_len 转换为网络字节序，记为 fl
将 fl 的 4 个字节追加到 buf

向 buf 追加 MAGIC 字节
向 buf 追加 VERSION 字节

将 req_id 转换为网络字节序，记为 rid
将 rid 的 4 个字节追加到 buf
```
共 10 字节，其中 4 字节帧长度，1 字节 MAGIC，1 字节版本号，4 字节请求 ID。随后根据不同的 Opcode 将 Key 和 Value 以二进制形式追加到 buf 中，最终返回完整的帧数据。

- *EncodeCustomRequest* 提供了更灵活的接口，允许用户直接传入任意 Payload，然后将通用帧头打包，适用于 OP_SHARD、OP_TABLET_STATS 和 OP_SCAN_RANGE 等特殊请求。

- *EncodeResponse* 接受一个 Status 和 Value，构造响应帧。响应帧计算 Value 的长度，然后写入 4B 的 ValueLen 字段，确保客户端能够正确解析响应内容。
```
向 buf 追加 status 字节

将 val_len 转换为网络字节序，记为 vl
将 vl 的 4 个字节追加到 buf

将 value 中的所有数据追加到 buf

返回 buf
```



=== 服务端 RpcServer 的实现
RpcServer 基于 POSIX @posix2017 socket API 实现了一个阻塞式 TCP 服务器。主循环调用 accept 接收新连接，每当有新的客户端连接到达时，创建一个新的工作线程来处理该连接，主线程继续等待下一个连接。这种"One Thread Per Connection"模型实现简单，适合并发连接数较少的研究场景。

连接的读写采用阻塞 I/O 模式 @jasny2025iouring  。RecvFrame 函数时服务端接收数据的核心，其逻辑如下：
```cpp
函数 RecvFrame(out, timeout_ms
    // 第一步：确保缓冲区中至少存在 4 字节 FrameLen
    当 recv_buf 的大小小于 4 时循环：
        从 socket 中读取数据到临时缓冲区 temp_buf
        如果读取失败：
            返回 false

        将读取到的数据追加到 recv_buf

    // 第二步：解析 FrameLen
    从 recv_buf 前 4 字节中解析 frame_len
    将 frame_len 从网络字节序转换为主机字节序

    // 第三步：持续读取，直到收到完整数据帧
    当 recv_buf 的大小小于 frame_len 时循环：
        从 socket 中继续读取数据到 temp_buf
        如果读取失败：
            返回 false

        将读取到的数据追加到 recv_buf

    // 第四步：提取完整数据帧
    将 recv_buf 前 frame_len 字节复制到 out

    从 recv_buf 中删除已经读取的 frame_len 字节

    返回 true
```
recv_buf\_ 是一个持久化的接收缓冲区，以 std::vector<uint8_t> 实现。每次 recv 将新数据追加到尾部，然后检查是否可以提取完整帧。这种设计保证了无论 TCP 如何拆包或粘包，应用层始终以帧为单位处理数据。

BinaryRpcServer 在 HandleClient 中调用用户注册的 handler 函数处理业务逻辑。Handler 返回纯 Payload（不含帧头），HandleClient 负责调用 EncodeResponse 打包完整帧并发送。这一约定确保了帧格式的一致性：



=== 请求端 RpcClient 的实现
RpcClient 也是基于 POSIX socket API 实现的一个 TCP 客户端，提供 Connect、SendFrame 和 RecvFrame 等基本方法。Connect 方法建立到服务器的 TCP 连接，SendFrame 方法将数据打包成帧格式发送，RecvFrame 方法与服务端相同，先读4字节帧长度，再读剩余字节，确保正确处理粘包和半包问题。

客户端支持连接状态检测（IsConnected），Master 在 BalancerLoop 中通过此接口判断管理通道是否存活。

== 客户端 APP 的设计与实现
=== 设计目标
lekv_cli 是 LEKV 系统的命令行客户端，其设计遵循一个核心原则：*客户端承担路由计算的职责，Master 只承担路由管理的职责*。这意味着：
- *数据流量不经过 Master*：客户端通过本地缓存的路由表直接定位到目标 DataNode，建立 TCP 连接后直接发送 OP_PUT / OP_GET / OP_DELETE 请求。数据读写完全在客户端与 DataNode 之间完成，Master 不参与任何数据传输。

- *减少 Master 负载*：Master 只需处理路由查询（OP_SHARDS）和内部管理通信，不必成为数据转发的瓶颈。

- *降低访问延迟*：省去了一层网络跳转（Client → Master → DataNode 变为 Client → DataNode），降低了单次请求的 RTT。

=== 路由缓存机制
客户端启动时，向 Master 发送一次 OP_SHARDS 请求，获取当前全部分片（Tablet）的路由信息，缓存到本地内存的 local_tablets\_ 数组中。CachedTablet 结构如下：
```cpp
struct CachedTablet {
    uint64_t id;
    std::string start_key;
    std::string end_key;
    std::string addr;  // DataNode 的 "IP:Port"
};
```
local_tablets\_ 按 *start_key* 升序排列，与 Master 端的路由表保持一致。

路由定位采用*二分查找*，算法与 Master 端的 FindTabletIndex 完全一致：给定一个 key，在 local_tablets\_ 中找到满足 start_key ≤ key < end_key 的 Tablet，返回其 addr 字段，作为目标 DataNode 的地址。时间复杂度 O(log N)。

=== 数据操作的完整流程
客户端执行一次数据操作（以 GET 为例）的完整流程如下：

#capfig(
  image("figures/LEKVClient_request.drawio.png", width: 100%),
  caption: [客户端执行请求流程示意图]
)

*第一步：路由定位*。 调用 DoGetRoute(key)，在 local_tablets\_ 上执行二分查找。若 local_tablets\_ 为空则先调用 RefreshTablets() 向 Master 重新拉取全量路由表，再进行查找。

*第二步：建立连接*。 客户端用查找到的 addr，创建 TCP 连接，连接到目标 DataNode。

*第三步：发送请求*。 调用 DoDataNodeRequest(addr, opcode, key, value)，使用 BinaryRpcClient 发送编码后的二进制帧，等待响应。请求帧格式为 [1B Opcode][2B KeyLen][4B ValueLen][Key][Value]，其中 ValueLen 在 GET/DELETE 时为 0。

*第四步：处理响应*。 解析响应帧的首字节 status：
ST_OK = 0x00：操作成功，GET 返回 value，PUT/DELETE 返回确认；
ST_NOT_FOUND = 0x01：key 不存在；
ST_NOT_MY_SHARD = 0x02：路由过期，进入第五步；
其他状态码：返回错误。

*第五步：缓存失效刷新*。 若收到 ST_NOT_MY_SHARD，说明该 key 已不在目标 DataNode 负责的 Tablet 范围内（Tablet 可能已分裂或迁移）。此时客户端重新执行 RefreshTablets() 获取最新路由表，然后重试原请求。若重试仍失败，则返回错误。


== 存储引擎模块的设计与实现
=== LevelDB 在系统中的应用
在 LEKV 中，LevelDB 承担底层持久化存储引擎的角色，位于 DataNode 节点内部，负责所有数据的实际存储、检索和持久化。具体而言，LevelDB 在系统中承担三方面职责：（1）键值数据的持久化存储；（2）键的天然有序性支持；（3）范围查询与迭代能力

LevelDB 本身不具备任何分布式能力，它只是一个单机嵌入式键值存储库。LEKV 在 LevelDB 之上通过 Master 实现分布式路由、通过 DataNode 实现网络接入、通过自定义协议实现跨节点通信，从而将单机存储能力扩展为分布式存储系统。



=== StorageEngine 类的实现
`StorageEngine` 类是对 LevelDB C++ API 的封装，提供线程安全的 KV 操作和范围查询接口。
#capfig(
  image("figures/Storage_arch.drawio.png", width: 50%),
  caption: [StorageEngine 类的设计示意图],
)

它包含以下主要成员函数：
- PUT / GET / DELETE：分别对应键值的写入、读取和删除操作，内部调用 LevelDB 的 `Put`、`Get` 和 `Delete` 方法，并进行错误处理和状态码转换。

- RangeQuery(start_key, end_key)：提供范围查询接口，返回指定范围内的所有键值对，时间复杂度为 O(logN)。内部使用 LevelDB 的迭代器功能，按照字典序遍历从 start_key 到 end_key 的键值对，并将它们打包成一个响应格式返回给调用方。
#capfig(
  image("figures/RangeQuery.drawio.png", height: 50%),
  caption: [StorageEngine 的 RangeQuery 操作流程示意图],
)

- RangeStats(start_key, end_key)：提供范围统计接口，调用RangeQuery，返回指定范围内的键值对数量和中位数键，时间复杂度为 O(logN + K)(K为区间内键值数)。内部同样使用 LevelDB 的迭代器功能，统计范围内的键值对数量，并在遍历过程中记录中位数键的位置，最终返回统计结果。

旧版系统存储引擎实现中，系统使用`std::unordered_map` 存储键值对，`RangeStats` 的实现需要遍历整个哈希表并手动排序，时间复杂度为 O(N logN)，性能完全不可接受



== 分片与负载均衡机制的设计与实现
=== 范围分片的设计与 Tablet 数据结构
第二章从理论层面分析了哈希分片与范围分片的各自优劣。LEKV 选择范围分片的核心依据在于：系统底层采用 LevelDB 存储引擎，其 LSM-Tree 结构天然保证 key 的字典序排列，范围分片可以充分利用这一特性实现高效的范围查询和统计；同时，以 Tablet 为独立单元进行迁移，避免了逐 key 搬迁的复杂性和不一致风险。

基于上述设计决策，LEKV 定义了 Tablet 结构体作为分片管理的基本单元：
```cpp
struct Tablet {
    uint32_t id;           // Tablet 唯一标识
    std::string start_key; // 区间起始（包含）
    std::string end_key;   // 区间结束（不包含），空表示 +∞
    uint32_t node_id;      // 负责该 Tablet 的 DataNode ID
    uint64_t key_count;    // 区间内键数量（近似值，定期同步）
};
```
`id` 全局唯一递增分配，`start_key`和`end_key`定义了改 Tablet 负责的 key 范围，`node_id` 指向负责该 Tablet 的 DataNode，`key_count` 用于负载均衡和分裂决策。

`tablets_` 以 std::vector<Tablet> 形式存储在 Master 中，按照 start_key 升序排序，支持二分查找定位 Tablet，时间复杂度为 O(log N)。路由表通过`std::shared_mutex` 保护：读操作（路由查询，SHARDS响应），写操作（负载均衡，数据迁移）使用unique_lock。

=== 初始分片建立
系统启动时，Master 的路由表为空，之后根据配置中的 DataNode 数量，将 key 的有序空间动态划分为等宽的区间。
- *1 个 DataNode*：一个 Tablet 负责整个 key 空间，区间为 ["", "")。
- *2 个 DataNode（默认配置）*：将 key 空间划分为两个区间，Tablet 1 ["", "m") 分配给节点 2，Tablet 2 ["m", "") 分配给节点 3。
- *3 个或以上 DataNode*：按照可见 ASCII 字符范围 [32, 126] 进行等宽划分。

初始分片建立后，客户端可以通过 OP_SHARDS 请求获取全量路由表并缓存到本地。此后所有数据写入都按照各自 key 所属的 Tablet 区间，被路由到对应的 DataNode 上。



=== 数据写入与 Tablet 数据增长
系统运行过程中，客户端持续向 DataNode 写入键值对。每个 Tablet 负责一个 key 区间，该区间内写入的 key 数量不断增长。以两个 DataNode 的默认配置为例：
- Tablet 1：区间 ["", "m")，负责存储 key 小于 "m" 的数据
- Tablet 2：区间 ["m", "")，负责存储 key 大于等于 "m" 的数据

由于实际 workload 中 key 的分布往往不是均匀的——例如大量 key 以 "a"~"l" 开头——Tablet 1 的 key 数量可能快速增长，而 Tablet 2 增长缓慢。当 Tablet 1 的 key_count 超过阈值 SPLIT_THRESHOLD = 10 （当前开发环境设置量较小）时，系统判定该 Tablet 过载，需要分裂。

key_count 的来源是 Master 的 BalancerLoop 后台线程，它每 5 秒向各 DataNode 发送 OP_TABLET_STATS 请求，扫描每个 Tablet 的区间统计键数量，更新到本地路由表中。


=== 自动分裂：从一个大 Tablet 到两个小 Tablet
*分裂触发*：Master 的 BalancerLoop 后台线程每5秒，通过`OP_TABLET_STATS` RPC 向各 DataNode 查询所有 Tablet 的 key_count 统计信息，更新到路由表中，当某个 Tablet 中的键值对数量超过预设的分裂阈值`SPLIT_THRESHOLD`（如当前开发环境为10条，生产环境可调整为1000条或更高）时，会执行分裂操作。分裂阈值的设置需要综合考虑系统的性能和资源利用率，过低的阈值可能导致频繁分裂增加系统开销，过高的阈值可能导致单个 Tablet 过大影响查询性能。

*分裂点的选择*：为了保证分裂后两个子 Tablet 的负载尽可能均衡，系统选择该 Tablet 区间内所有 key 的中位数作为分裂边界。中位数的获取方式是通过 OP_TABLET_STATS 请求——DataNode 使用 LevelDB Iterator 扫描区间，将所有 key 收集到数组中，取 keys[count / 2] 作为中位数返回。

*分裂执行流程*
Tablet 分裂执行分为三步：

步骤一：防御性拷贝。Master 在读取 Tablet 路由表时，首先获取读锁`shared_lock`，将目标 Tablet 的信息复制到栈变量`old_t`，就后立即释放锁。此时`old_t` 中的 Tablet 信息是一个快照，后续的分裂操作都基于这个快照不持有任何锁进行，避免了长时间持锁导致的性能瓶颈和死锁风险。

步骤二：无锁RPC查询。Master 使用`old_t` 中的 Tablet 区间信息，向负责该 Tablet 的 DataNode 发送 `OP_TABLET_STATS` 请求，获取当前 Tablet 中的键值对数量和中位数键。由于不持有锁，Master 的其他线程可以同时正常读取路由表。

步骤三：一次性加锁修改。当 Master 收到响应后，获取写锁 `unique_lock`，执行一下原子操作：

（1）防御性校验：检查目标位置的 Tablet 是否仍然是`old_t`，如果不一致说明在分裂过程中该 Tablet 已经被其他线程修改过，放弃本次分裂操作，直接返回。

（2）构造左子 Tablet：使 left = {new_id, old_t.start_key, median_key, old_t.node_id, old_t.key_count / 2}，其中 new_id 是一个全局唯一的 TabletID 生成器生成的新 ID。

（3）构造右子 Tablet：使 right = {new_id + 1, median_key, old_t.end_key, old_t.node_id, old_t.key_count - left.key_count}，重用原 TabletID 作为右子 Tablet 的 ID。

（4）更新路由表：将原 Tablet 替换为 left 和 right 两个子 Tablet，更新全局路由表。

（5）释放写锁
整个写锁的持有时间内仅执行纯内存操作（数组元素赋值和插入），不涉及任何网络 I/O，因此锁持有时间极短（通常在微秒级别），对系统并发性能影响可忽略。

#capfig(
  image("figures/SplitTablet.drawio.png", height: 50%),
  caption: [Tablet 分裂执行流程示意图]
)

*分裂示例*：假设 Tablet 1 ["", "m") 中存储了 12 个 key，排序后为 ["apple", "banana", "cat", "dog", "egg", "fish", "goat", "hat", "ice", "jam", "kite", "lion"]。中位数为 keys[6] = "goat"，分裂后：
- Tablet 3（新）：["", "goat")，key 为 apple ~ hat（6 个）；
- Tablet 4（新）：["goat", "m")，key 为 ice ~ lion（6 个）。

分裂后两个 Tablet 负载均衡，且仍由同一 DataNode 负责。此时路由表包含 3 个 Tablet：Tablet 2 ["m", "")、Tablet 3 ["", "goat")、Tablet 4 ["goat", "m")

Master 启动后会创建一个名为 BalancerLoop 的后台线程，定期执行负载均衡和分裂检查。该线程每5秒钟执行一次以下操作：
```
函数 BalancerLoop()
    当系统处于运行状态时循环执行：
        等待 5 秒

        // 第一步：同步所有 Tablet 的统计信息
        同步所有 Tablet 的统计数据到路由表

        // 第二步：检查是否需要进行 Tablet 分裂
        如果存在需要分裂的 Tablet：

            尝试执行 Tablet 分裂

            // 分裂后负载情况可能发生变化
            跳过本次负载均衡检查
            继续下一轮循环

        // 第三步：检查是否需要进行负载均衡
        检查并执行负载均衡
```
该循环每5秒执行一次，优先处理 Tablet 分裂，分裂后可能会改变负载分布，因此跳过本次负载均衡检查；如果不需要分裂，则继续检查是否需要负载均衡。通过这种方式，系统能够定期调整分片和负载分布，保持系统的性能和稳定性。



=== 负载均衡：从均衡到均衡的迁移
*问题产生*：持续的分裂操作和不对称的数据写入，会导致不同 DataNode 上的 Tablet 总负载出现差异。以两节点场景为例：假设 Tablet 1 经过多次分裂产生 4 个子 Tablet 全部在节点 2 上，而 Tablet 2 在节点 3 上始终未分裂，则节点 2 的 key 数量可能是节点 3 的数倍。

*节点负载统计*：Master 采用*键数量差值比较法*作为负载均衡的决策依据：遍历当前路由表，累加每个 DataNode 上所有 Tablet 的 key_count，得到各节点的总负载 node_load[node_id]。然后找出负载最高和最低的节点，计算两者的负载差值 diff = max_load - min_load。若 diff >= BALANCE_DIFF_THRESHOLD（当前开发环境设置为 8），则判定需要执行负载均衡。

选择差值比较，而放弃比率比较的原有在于，当某个节点的负载非常低（如1条，甚至为0），即使另一个节点的负载较高（如1000条），其比率差值可能出现除0或者数值爆炸的问题；而差值比较则更关注绝对的负载差异，只有当两个节点之间的键数量差异达到一定程度时才会触发负载均衡。

*迁移对象选择*：从负载最高的节点上，选择 key_count 最大的那个 Tablet 作为迁移对象。这样每次迁移都能最大程度地缩小节点间的负载差距。

*数据迁移：Scan + Transfer*：Master 会从负载最高的节点上选择一个`key_count`最大的 Tablet 进行迁移，迁移过程分为三步：

- Scan 阶段：Master 向源节点发送 `OP_SCAN_RANGE` 请求，指定该 Tablet 的 start_key 和 end_key，要求 DataNode 返回该范围内的所有键值对。DataNode 通过 LevelDB 的迭代器功能扫描该范围内的键值对，并将它们打包成响应帧返回给 Master，返回的格式为*[4B count] [count \* (2B KeyLen + key + 4B ValueLen + value]*。

- Transfer 阶段：Master 收到响应后，解析出所有键值对，然后向目标节点发送一系列 `OP_PUT` 请求，将这些键值对写入目标节点的 LevelDB 中。每个 `OP_PUT` 请求包含一个键值对的完整信息，DataNode 接收到请求后执行写入操作并返回结果。每条 PUT 都等待目标节点的 `ST_OK` 确认后才发送下一条。

- 路由表更新：数据迁移完成后，Master 需要原子地更新路由表，使得后续请求能够正确路由到新的节点。

*迁移示例*：假设 Tablet 4 ["goat", "m") 有 6 个 key，当前在节点 2 上。节点 2 总负载 18，节点 3 总负载 4，diff = 14 >= 8，触发均衡。Master 将 Tablet 4 迁移到节点 3：先扫描出全部 6 个 key-value 对，逐条 PUT 到节点 3，然后修改路由表中 Tablet 4 的 node_id 为 3。迁移后节点 2 负载 12，节点 3 负载 10，diff = 2 < 8，达到均衡。
#capfig(
  image("figures/load_balance.drawio.png", width: 100%),
  caption: [负载均衡执行流程示意图]
)

`DoLoadBalance` 函数实现了负载均衡的核心逻辑，首先计算各节点的总负载（key_count），找出负载最高和最低的节点，判断是否需要执行负载均衡。若需要，则选择负载最高节点上 key_count 最大的 Tablet 进行迁移，先通过 `OP_SCAN_RANGE` 获取该 Tablet 的所有键值对，然后逐条发送 `OP_PUT` 请求将它们写入目标节点。最后原子地更新路由表，使得后续请求路由到新的节点。
```
函数 DoLoadBalance()

    获取 tablet_mutex_ 的写锁

    // 第一步：统计每个节点的负载
    创建 node_load 映射表

    遍历所有 Tablet：
        将当前 Tablet 的 key_count 累加到对应节点负载中

    // 第二步：找到负载最高与最低的节点
    找到负载最大的节点 max_it
    找到负载最小的节点 min_it

    计算负载差值 diff

    如果 diff 小于 BALANCE_DIFF_THRESHOLD：
        返回 false

    // 第三步：选择需要迁移的 Tablet
    src ← 负载最高节点
    dst ← 负载最低节点

    在源节点 src 上：
        找到 key_count 最大的 Tablet
        记录其下标为 target_idx

    // 第四步：释放锁后执行迁移
    释放 tablet_mutex_ 锁

    执行 Tablet 迁移：
        将 target_idx 对应 Tablet 迁移到 dst 节点

    返回迁移结果
```
`MigrateTablet` 调用`ScanAndTransferData`完成真实的数据搬迁。该函数向源 DataNode 发送 OP_SCAN_RANGE 请求获取区间内全部键值对，然后逐条向目标 DataNode 发送 OP_PUT 写入。迁移完成后，通过写锁原子更新路由表中该 Tablet 的 node_id 字段。



=== 分片与负载均衡的完整闭环
将上述过程串联，LEKV 的分片与负载均衡形成一条完整的自动调节链：
```
系统启动 → 初始分片建立（按节点数均分）
    ↓
数据写入 → Tablet 膨胀（key_count 增长）
    ↓
key_count > 10 → 自动分裂（以中位数为界一分为二）
    ↓
多次分裂后 → 节点间负载不均（diff >= 8）
    ↓
负载均衡触发 → 最高负载节点Scan + Transfer 迁移 Tablet 到低负载节点
    ↓
负载均衡达成 → 继续监控，循环往复
```



== 本章小结
本章详细介绍了 LEKV 系统开发进度管理、网络通信模块的设计与实现、客户端 APP 的设计与实现、存储引擎模块的设计与实现，以及分片与负载均衡机制的设计与实现。通过这些模块的协同工作，LEKV 实现了一个功能完整、性能可观的分布式键值存储系统。


= 系统测试与分析
== 测试环境搭建
=== 硬件与软件环境
系统的测试环境与开发环境基本一致，使用同一台个人笔记本电脑，配置如下：
#captab(
  caption: [测试环境配置],
  placement: none,
)[
  | 设备名称 | 配置 |
  | --- | --- |
  | 操作系统 | Windows 11 (WSL Ubuntu 22.04 LTS) |
  | CPU | 11th Gen Intel(R) Core(TM) i5-11260H @ 2.60GHz |
  | 内存 | 8GB (分配给 WSL) |
  | 网络 | 本地环回接口 (127.0.0.1) |
  | 编译器 | GCC 11.4.0 |
  | CMake | 3.22.1 |
  | Python | 3.13.12 (测试脚本) |
]

=== 部署方式
采用单机三进程模拟分布式部署
- Master 进程：监听 127.0.0.1:9001
- DataNode 1 进程：监听 127.0.0.1:9002，数据目录 db_2/
- DataNode 2 进程：监听 127.0.0.1:9003，数据目录 db_3/
三进程通过 TCP 本地回环接口通信，网络延迟可忽略（< 0.1ms），测试结果主要反映系统的功能正确性和算法效率，而非网络性能。

=== 测试工具
测试主要通过自定义的 python 测试脚本 `test_lekv.py` 实现，使用 Python 的 `socket` 模块模拟客户端行为，直接构造二进制协议帧与 Master 通信。测试脚本包含以下功能：
- 路由查询与全量路由表拉取：验证 OP_GET_ROUTE 和 OP_SHARDS 请求的正确性。
- 基本 CRUD 操作测试：验证 PUT/GET/DELETE 的正确性和基本性能。
- 自动分裂触发测试：通过批量写入数据触发 Tablet 分裂，验证分裂后的路由表更新和数据正确性。
- Tablet 区间统计测试：验证 OP_TABLET_STATS 请求的正确性和性能。
- 写入/读取性能基准测试
- 持久化文件存在性测试：验证 LevelDB 数据文件的正确生成和更新。

=== 部署方式
采用单机三进程分布式不是，通过 test.sh 脚本一键启动
```bash
# 1. 清理历史数据
rm -rf *.log db_* *.json

# 2. 启动三个服务端进程
./../build/bin/lekv 9002 > /dev/null 2>&1 &   # DataNode
./../build/bin/lekv 9003 > /dev/null 2>&1 &   # DataNode
./../build/bin/lekv 9001 > /dev/null 2>&1 &   # Master
sleep 1                                       # 等待初始化完成
```
test.sh 启动服务端后调用`python test_lekv.py --auto-start all` 执行全部测试，结束后通过 `pkill lekv` 停止所有服务端进程。

== 功能测试
=== 基本 CRUD 测试
*测试目的*：验证系统的写入、读取、删除和路由查询功能是否正确实现。

*测试数据*：选取5个 key，覆盖两个 Tablet 区间

#captab(
  caption: [测试数据与路由预期],
  placement: none,
)[
  | Key    | 首字母 | 预期 Tablet      | 预期 DataNode |
| ------ | --- | -------------- | ----------- |
| apple  | a   | T1 `["", "m")` | 9002        |
| banana | b   | T1 `["", "m")` | 9002        |
| mango  | m   | T2 `["m", "")` | 9003        |
| peach  | p   | T2 `["m", "")` | 9003        |
| zebra  | z   | T2 `["m", "")` | 9003        |
]

*测试步骤*：
+ *写入验证 PUT*：对上述5个 key，先发送 GET_ROUTE 查路由，再直连 DataNode发送 OP_PUT 请求，验证每个请求返回 ST_OK
+ *读取验证 GET*：对上述5个 key，先发送 GET_ROUTE 查路由，再直连 DataNode发送 OP_GET 请求，验证返回的 value 与写入时一致
+ *删除验证 DELETE*：对 key = "zebra"，执行 OP_DELETE 请求，验证返回 ST_OK；随后执行 OP_GET 请求，验证返回 ST_NOT_FOUND
+ *全量路由表 SHARDS*：发送 OP_SHARDS 请求，验证返回的 Tablet 数量、区间范围、负责节点等信息与预期一致

*测试结果*
#captab(
  caption: [基本 CRUD 测试结果],
  placement: none,
)[
| 步骤  | 测试项 | 预期结果 | 实际结果 |
| --- | ----------------- | --------------------- | ---- |
| 1.3 | PUT apple → 9002  | ST\_OK                | ST_OK |
| 1.3 | PUT banana → 9002 | ST\_OK                | ST_OK |
| 1.3 | PUT mango → 9003  | ST\_OK                | ST_OK |
| 1.3 | PUT peach → 9003  | ST\_OK                | ST_OK |
| 1.3 | PUT zebra → 9003  | ST\_OK                | ST_OK |
| 1.4 | GET apple         | value_of_apple      | value_of_apple |
| 1.4 | GET banana        | value_of_banana     | value_of_banana |
| 1.4 | GET mango         | value_of_mango      | value_of_mango |
| 1.4 | GET peach         | value_of_peach      | value_of_peach |
| 1.4 | GET zebra         | value_of_zebra      | value_of_zebra |
| 1.5 | DELETE zebra      | ST_OK                | ST_OK |
| 1.5 | GET zebra (删除后) | ST_NOT_FOUND        | ST_NOT_FOUND |
| 1.2 | SHARDS            | 2 Tablets             | 2 1::m:127.0.0.1:9002 2:m::127.0.0.1:9003 |
]

=== 持久化测试
*测试目的*：验证数据的持久化存储功能，确保数据在写入后正确保存在磁盘上，并且在系统重启后能够正确读取。

*测试步骤*：停止所有服务端进城后，检查 DataNode 的数据目录（db_2/ 和 db_3/）中是否存在 LevelDB 的数据文件（如 LOG、MANIFEST、SST 文件等）。随后重新启动服务端进程，执行 GET 请求验证之前写入的数据是否能够正确读取。

*测试结果*：
#captab(
  caption: [持久化检查结果],
  placement: none,
)[
| DataNode | 数据目录 | 文件列表 | 数据文件数量 |
| -------- | ------  | ----     |  ---------- |
| 9002     | db_2/   | 000003.log CURRENT LOCK LOG MANIFEST-000002  | 1 |
| 9003     | db_3/   | 000003.log CURRENT LOCK LOG MANIFEST-000002 | 1 |

]

== 性能测试
=== 测试方法
基于 `test_performance` 函数，通过批量写入和读取大量键值对来测试系统的性能表现。测试步骤如下：
- 测试数据量：1000条键值对
- Key 格式：perf_0000 ~ perf_0999
- Value 大小：100字节固定字符串（"x" \* 100）
- 测试方式：串行执行操作
- 连接优化：启动`TCP_NODELAY`选项，减少网络延迟对性能的影响
- PUT 和 GET 共用同一 TCP 连接，GET 测试前随机打乱key顺序

=== 测试步骤
+ 通过 GET_ROUTE 查询 perf_0000 的路由信息，确认目标 DataNode
+ 依次对 perf_0000 ~ perf_0999 发送 OP_PUT 请求，记录总耗时
+ 随机打乱 perf_0000 ~ perf_0999 的顺序，依次发送 OP_GET 请求，记录总耗时
+ 计算吞吐量和平均延迟，结果写入`perf_result.txt`文件
+ 通过`perf_result.txt`分析系统的写入和读取性能，评估系统在处理大量数据时的表现。

=== 测试结果
#captab(
  caption: [性能测试结果],
  placement: none,
)[
  | 操作类型 | 操作数 | 吞吐量(QPS) | 平均延迟(ms) |
| --- | --- | --- | --- |
| PUT  | 1000 | 4555.0 | 0.220 |
| GET  | 1000 | 4472.1 | 0.224 |
]

== 测试结果与分析
=== 功能验证总结
通过上述路由查询、基本CRUD和持久化三个维度的测试，验证了
- *路由定位*：GET_ROUTE 和 SHARDS 请求能够正确返回 Tablet 的区间范围、负责节点等信息，客户端能够根据路由信息正确路由到对应的 DataNode。
- *数据读写*：对key 进行 PUT 和 GET 操作，验证了数据能够正确写入和读取，DELETE 操作也能正确删除数据。
- *持久化*：通过检查 LevelDB 数据文件的存在性和更新情况，验证了数据的持久化存储功能。

=== 性能分析
PUT 吞吐量通常低于 Get，原因：
- PUT 涉及数据写入和磁盘 I/O，受限于存储引擎的性能；GET 主要是读取操作，通常更快。
- PUT 数据后 MemTable 和 SSTable 的写入和合并过程可能引入额外的延迟，尤其在数据量较大时更明显。


= 总结与展望
== 工作总结
本项目设计并实现了一个基于范围分片的分布式键值存储系统 LEKV，采用 Master + DataNode 双层架构，支持自动分裂和负载均衡功能。系统通过自定义二进制通信协议实现高效的网络通信，客户端通过路由查询直接与 DataNode 通信执行数据操作。系统的核心功能模块已经基本完成，并通过一系列功能测试和性能测试验证了系统的正确性和效率。
论文的主要工作与成果如下：

=== 系统架构设计
LEKV 采用 Master + DataNode 双层架构，将请求路由与数据存储解耦。Master 作为无状态路由代理层，维护全局 Tablet 路由表，运行 BalancerLoop 后台线程负责自动分裂和负载均衡；DataNode 作为有状态数据存储层，运行 LevelDB 引擎处理实际的键值读写。客户端通过缓存路由表直连 DataNode，降低了 Master 的转发压力。该架构清晰简洁，核心代码约 3000 行，适合研究和快速原型开发。

=== 自定义二进制通信协议
设计并实现了一套紧凑的自定义二进制通信协议，帧格式由 FrameLen、Magic、Version、RequestID 和 Payload 组成。协议定义了七类操作码，覆盖路由查询（GET_ROUTE）、数据读写（PUT/GET/DELETE）、分片管理（SHARDS、TABLET_STATS）和数据迁移（SCAN_RANGE）。采用长度前缀法解决 TCP 粘包问题，确保接收方能够可靠地从字节流中还原完整帧。相比 HTTP/JSON 文本协议，二进制协议解析更快、带宽占用更低。

=== 范围分片与路由机制
采用基于范围分片（Range-based Sharding）的数据分布策略，将 key 的有序空间划分为连续区间（Tablet），每个 Tablet 由特定 DataNode 负责存储。路由定位通过二分查找在 O(log N) 时间内完成，客户端缓存路由表并在失效时通过 ST_NOT_MY_SHARD 刷新。范围分片充分利用了 LevelDB 的键有序特性，支持高效的范围查询和区间统计。

=== 自动分裂与负载均衡
实现了 Tablet 自动分裂机制：当 Tablet 键数超过 SPLIT_THRESHOLD 时，BalancerLoop 通过 LevelDB RangeStats 获取中位数键，将原 Tablet 一分为二。提出了"栈拷贝 + 无锁 RPC + 一次性加锁"的并发安全设计模式，彻底消除了迭代器失效和死锁风险。实现了基于差值比较的负载均衡策略，通过 Scan + Transfer 机制完成 Tablet 数据的真实迁移。

=== LevelDB 存储引擎封装
封装了 LevelDB 作为 DataNode 的存储引擎，提供线程安全的 PUT/GET/DELETE 和 RangeQuery 接口。通过 RangeQuery 实现了 Tablet 分裂时的中位数键统计和负载均衡时的数据迁移。LevelDB 的高性能和稳定性为 LEKV 提供了坚实的存储基础。

== 存在的不足
尽管 LEKV 已经实现了核心功能并通过测试验证了系统的正确性和效率，但仍存在一些不足和待完善的方面：

=== 未实现完整的 Raft 共识算法
当前系统采用单副本架构，每个 Tablet 只存储在一个 DataNode 上。若该节点宕机，其负责的 Tablet 数据将不可访问。代码中虽然预留了 RaftState 枚举和状态机框架，但尚未实现 Leader 选举、日志复制和多数派提交等核心机制。

=== Master 的单点故障问题
当前系统的 Master 作为整个系统的路由中心和负载均衡器，如果 Master 宕机，客户端将无法获取路由信息，导致整个系统不可用。虽然 DataNode 之间可以通过心跳机制检测 Master 的状态，但缺乏自动切换到备用 Master 的机制。

=== 数据迁移的性能优化空间
负载均衡中的数据迁移采用逐条 PUT 写入方式（ScanAndTransfer），对于键数量较大的 Tablet，迁移过程耗时较长。此外，迁移期间没有事务保证，若中途失败可能导致目标节点数据不完整。


== 未来工作展望
针对上述不足，未来的工作计划包括：

=== 实现完整的 Raft 多副本复制
实现 Raft 共识算法，支持每个 Tablet 在多个 DataNode 上存储副本，通过 Leader 选举和日志复制机制保证数据的高可用性和一致性。这样即使某个 DataNode 宕机，系统仍能通过其他副本提供服务。

=== Master 的高可用设计
设计 Master 的主备复制机制，支持自动故障转移。当主 Master 宕机时，备用 Master 能够迅速接管路由服务，保证系统的持续可用性。同时实现 Master 之间的状态同步，确保备用 Master 能够无缝接管。

=== 数据迁移性能优化
引入批量写入（Batch Put）和流水线传输，减少迁移过程中的网络往返次数。增加迁移事务支持：在目标节点完成全部数据写入并校验后，原子地切换路由表，确保迁移的原子性。

