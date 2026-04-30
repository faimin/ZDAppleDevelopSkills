# ZDAICollection
iOS development AI agent skills collection

## 自建 iOS Skills 使用说明

当前仓库内置的 iOS Skills 位于 `AppleDevelopSKILLS/skills/`，建议把它们理解为一套分层路由：

- `ios-app-development`：总入口 Skill
- `swift-modern`：现代 Swift 语言与应用代码
- `objective-c-patterns`：Objective-C 语言特性与遗留模块模式
- `uikit-modern`：UIKit 页面与列表现代化
- `project-structure-architecture`：工程结构、架构、包管理与三方库选型

### 1. `ios-app-development`

这是默认入口 Skill。只要需求是比较宽泛的 iOS 开发任务，优先让它先触发。

适用场景：

- “做一个 iOS 页面 / 功能 / 模块”
- “重构一个 iOS 需求”
- “review 这个 iOS 项目改动”
- “这段 Swift / Objective-C / UIKit 代码该怎么拆”
- “这个 iOS 工程结构应该怎么设计”

它本身不提供大段技术细节，主要负责把问题继续路由到更具体的 specialist skill。

### 2. `swift-modern`

这个 Skill 用来处理 Swift `4.2-6.3` 范围内的现代 Swift 开发问题。

适用场景：

- Swift 语法升级、迁移、版本差异
- `async/await`、actor、`Sendable`、并发隔离
- Combine、Codable、`@Observable`
- Swift Testing
- Swift 与 Objective-C 互操作
- SwiftUI-first 的状态与 UI ownership 问题

典型提问方式：

- “这段 Swift 代码应该用 Concurrency 还是 Combine？”
- “Swift 6 下这个 `Sendable` 报错怎么处理？”
- “Codable 同时兼容 `String` 和 `Int` 怎么建模？”

### 3. `objective-c-patterns`

这个 Skill 用来处理 Objective-C 语言与传统 iOS 模块中的核心模式问题。

适用场景：

- block、ARC、循环引用、`EXC_BAD_ACCESS`
- runtime、swizzle、forwarding、associated object
- category 设计边界
- KVC / KVO
- Objective-C 与 Swift 混编边界

典型提问方式：

- “这个 block 为什么会循环引用？”
- “这里要不要 swizzle？”
- “category 里放这段逻辑合适吗？”

### 4. `uikit-modern`

这个 Skill 聚焦 UIKit，尤其是 iOS 13 之后的现代 UIKit 写法。

适用场景：

- `UICollectionView` 优先的列表/网格页面
- `DiffableDataSource`
- `CompositionalLayout`
- `UIKeyboardLayoutGuide`
- scene / navigation / presentation
- 旧 UIKit 页面现代化重构

典型提问方式：

- “这个列表页该用 `UITableView` 还是 `UICollectionView`？”
- “如何把旧的 `reloadData` 改成 diffable data source？”
- “键盘遮挡输入框怎么用新 API 处理？”

### 5. `project-structure-architecture`

这个 Skill 负责工程层面的决策，而不是单个页面或单段代码。

适用场景：

- 工程目录结构设计
- Feature-first 分层
- MVVM / MVI / TCA / Redux 选型
- SPM / CocoaPods 选择
- 三方库选型
- 模块边界、资源 bundle、国际化 `.xcstrings`

典型提问方式：

- “这个 iOS 工程应该怎么分目录？”
- “这个模块适合 MVVM 还是 TCA？”
- “SPM 和 CocoaPods 这里该怎么选？”

### 推荐使用方式

如果你不确定某个问题该命中哪个 Skill，优先走：

1. `ios-app-development`
2. 再由它路由到下面四个 specialist skills

如果问题本身已经非常明确，也可以直接命中对应 Skill：

- 语言 / 并发 / Codable / Combine / SwiftUI 状态：`swift-modern`
- Objective-C / block / runtime / 混编：`objective-c-patterns`
- UIKit 页面 / 列表 / 键盘 / 导航：`uikit-modern`
- 架构 / 目录 / 包管理 / 三方库：`project-structure-architecture`

### 与 `AGENTS.md` 的分工

当前仓库里的职责边界是：

- `AGENTS.md`：仓库级规则、工作流、安全约束、测试要求、Skill 路由规则
- `AppleDevelopSKILLS/skills/`：可复用的 Apple / iOS 领域知识与决策规则

换句话说，通用 iOS 规范不要继续堆回 `AGENTS.md`，优先沉淀到对应 Skill 里。

------
------

## TOOLS

- [cc-switch](https://github.com/farion1231/cc-switch): 快速切换AI
- [cc-connect](https://github.com/chenhg5/cc-connect): 在任何聊天工具里，远程操控你的本地 AI Agent
- [ccx](https://github.com/BenedictKing/ccx): CCX是Claude、OpenAI Chat Codex Responses和Gemini的高性能AI API代理和协议翻译网关。它提供了一个统一的入口点、内置的网络管理、故障转移、多密钥管理、渠道编排和模型路由。
- [AgentSkills](https://github.com/chrlsio/agent-skills) - agent skills管理器
- [rtk](https://github.com/rtk-ai/rtk) - 降低LLM token消耗
- [caveman](https://github.com/JuliusBrussee/caveman) - 降低token
- [graphify](https://github.com/safishamsi/graphify) - 项目结构图

## MCP

- [apple-docs-mcp](https://github.com/kimsungwhee/apple-docs-mcp): 苹果官方文档MCP
- [string-catalog-mcp](https://github.com/onmyway133/string-catalog-mcp): Xcode国际化
- [lanhu-mcp](https://github.com/MrDgbot/lanhu-mcp)

## SKILLS

- [superpowers](https://github.com/obra/superpowers): 一套行之有效的软件开发方法论
- [gstack](https://github.com/garrytan/gstack)
- [Get Shit Done](https://github.com/gsd-build/get-shit-done): 项目管理系统，快速创建一个项目
- [gsd-sp-enhancement](https://github.com/yiixiahulun/gsd-sp-enhancement)
- [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

- [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill): 让AI写出来的UI更美观
- [Super Skills](https://github.com/onmyway133/skills)
- [Swift-UIKit-Skill](https://github.com/Lakr233/Swift-UIKit-Skill)
- [MixMax Skills](https://github.com/MiniMax-AI/skills)
----
- [app-store-connect-cli-skills](https://github.com/rudrankriyam/app-store-connect-cli-skills)
----
- [ios-dev-skills](https://github.com/12207480/ios-dev-skills)
- [Swift-Concurrency-Agent-Skill](https://github.com/AvdLee/Swift-Concurrency-Agent-Skill): Swift并发编程Agent技能
- [SwiftUI-Agent-Skill](https://github.com/AvdLee/SwiftUI-Agent-Skill): SwiftUI Agent技能
- [SwiftUI-Agent-Skill](https://github.com/twostraws/SwiftUI-Agent-Skill): SwiftUI Agent技能
- [xcode-cli-skill](https://github.com/dazuiba/xcode-cli-skill): Xcode CLI Agent技能
- [dotclaude](https://github.com/FradSer/dotclaude)
