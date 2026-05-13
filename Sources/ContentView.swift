import SwiftUI

// 这是预览块的种类。
enum PreviewKind: String, CaseIterable, Identifiable {
  // 纯文本卡。
  case note

  // 图标横条。
  case tools

  // 统计卡片。
  case report

  // 让 ForEach 可识别。
  var id: String { rawValue }

  // 显示标题。
  var title: String {
    switch self {
    case .note:
      return "Text 风格"
    case .tools:
      return "HStack 风格"
    case .report:
      return "VStack 风格"
    }
  }
}

// 这是统一装箱后的 widget 数据。
struct ShelfWidget: Identifiable {
  // 唯一 id。
  let id = UUID()

  // 说明标题。
  let title: String

  // 被装箱后的 View。
  let view: AnyView
}

// 这是主界面；专门拿来讲 `AnyView`。
struct ContentView: View {
  // 当前选中的预览种类。
  @State private var selectedKind: PreviewKind = .note

  // 右侧日志。
  @State private var logs: [String] = []

  // 左下货架里放 3 个不同具体类型的 View，但统一装进 AnyView。
  private let shelfWidgets: [ShelfWidget] = [
    ShelfWidget(
      title: "Text 盒子",
      view: AnyView(
        Text("我是纯文本 widget")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(14)
          .background(Color.pink.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 12))
      )
    ),
    ShelfWidget(
      title: "HStack 盒子",
      view: AnyView(
        HStack {
          Image(systemName: "hammer.fill")
          Text("我是工具横条")
          Spacer()
          Text("2 items")
            .font(.caption.weight(.bold))
        }
        .padding(14)
        .background(Color.green.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
      )
    ),
    ShelfWidget(
      title: "VStack 盒子",
      view: AnyView(
        VStack(alignment: .leading, spacing: 6) {
          Text("周报摘要")
            .font(.headline)

          Text("完成 8 项，待跟进 2 项。")
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
      )
    )
  ]

  // 主布局。
  var body: some View {
    // 顶部说明 + 左右两栏。
    VStack(alignment: .leading, spacing: 16) {
      headerCard

      HStack(alignment: .top, spacing: 16) {
        examplesPanel
        lessonPanel
      }
    }
    .padding(20)
    .frame(minWidth: 1220, minHeight: 840)
  }

  // 顶部说明。
  private var headerCard: some View {
    // 先把概念直接说白。
    VStack(alignment: .leading, spacing: 10) {
      Text("`AnyView` = 把不同具体 View 装进同 1 个标准盒子")
        .font(.system(size: 28, weight: .bold))

      Text("它的关键词是“类型擦除”。外面只看见 `AnyView`，里面其实可能装着 `Text`、`HStack`、`VStack` 等完全不同结构。")
        .foregroundStyle(.secondary)

      HStack(spacing: 10) {
        badge("统一包装")
        badge("擦掉具体类型名")
        badge("能用但别乱用")
      }
    }
    .padding(18)
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 左侧示例区。
  private var examplesPanel: some View {
    // 上半部分切换预览；下半部分展示异构数组。
    VStack(alignment: .leading, spacing: 16) {
      Text("左边：感受 2 个典型场景")
        .font(.headline)

      Text("场景 1：切换完全不同的具体 View")
        .font(.subheadline.weight(.semibold))

      HStack(spacing: 10) {
        ForEach(PreviewKind.allCases) { kind in
          Button(kind.title) {
            selectedKind = kind
            logs.insert("切到 \(kind.title)。当前具体 View 已换，但外面统一还是 AnyView。", at: 0)
          }
          .buttonStyle(.borderedProminent)
          .tint(selectedKind == kind ? .blue : .gray)
        }
      }

      previewBox

      Text("场景 2：同 1 个数组里装不同具体 View")
        .font(.subheadline.weight(.semibold))

      VStack(alignment: .leading, spacing: 10) {
        ForEach(shelfWidgets) { widget in
          VStack(alignment: .leading, spacing: 6) {
            Text(widget.title)
              .font(.caption)
              .foregroundStyle(.secondary)

            widget.view
          }
        }
      }
    }
    .padding(18)
    .frame(width: 590, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 当前预览盒。
  private var previewBox: some View {
    // 这里显示的其实是被 AnyView 装箱后的结果。
    makePreview(for: selectedKind)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  // 右侧讲解区。
  private var lessonPanel: some View {
    // 规则、建议、日志放一起。
    VStack(alignment: .leading, spacing: 14) {
      Text("右边：把 `AnyView` 的边界讲清")
        .font(.headline)

      insightCard(
        title: "它解决什么",
        bodyText: "当你真要把不同具体类型的 View 统一装到同 1 个位置、同 1 个数组、同 1 个返回类型里时，`AnyView` 很直接。"
      )

      insightCard(
        title: "它牺牲什么",
        bodyText: "它把具体类型信息擦掉了。所以平时如果 `some View`、`@ViewBuilder`、泛型能搞定，就优先别上 `AnyView`。"
      )

      insightCard(
        title: "快递箱比喻",
        bodyText: "里面可能是书、水杯、耳机。外面仓库系统只认“标准箱”。`AnyView` 就是这个标准箱。"
      )

      Text("日志")
        .font(.headline)

      ScrollView {
        LazyVStack(alignment: .leading, spacing: 10) {
          ForEach(Array(logs.enumerated()), id: \.offset) { _, line in
            Text(line)
              .font(.system(.body, design: .monospaced))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(12)
              .background(Color.primary.opacity(0.04))
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
      }
      .overlay {
        if logs.isEmpty {
          Text("点左边切换按钮，体会具体 View 已换，但统一包装仍是 AnyView。")
            .foregroundStyle(.secondary)
        }
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 这是核心工厂；用 AnyView 把不同具体 View 统一包装后返回。
  private func makePreview(for kind: PreviewKind) -> AnyView {
    // 分支里每个具体 View 结构都不同。
    switch kind {
    case .note:
      return AnyView(
        Text("这里原本是 1 块纯文本说明。现在它被包成 AnyView 返回。")
          .font(.title3.weight(.semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(18)
          .background(Color.pink.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 14))
      )
    case .tools:
      return AnyView(
        HStack(spacing: 12) {
          Label("导出", systemImage: "square.and.arrow.up.fill")
          Label("收藏", systemImage: "star.fill")
          Spacer()
          Button("记录 HStack") {
            logs.insert("当前预览里真正装的是 HStack。", at: 0)
          }
        }
        .padding(18)
        .background(Color.green.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
      )
    case .report:
      return AnyView(
        VStack(alignment: .leading, spacing: 10) {
          Text("周统计")
            .font(.headline)

          Text("新增 12 条，处理完成 9 条。")
            .foregroundStyle(.secondary)

          Button("记录 VStack") {
            logs.insert("当前预览里真正装的是 VStack。", at: 0)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
      )
    }
  }

  // 通用说明卡。
  private func insightCard(title: String, bodyText: String) -> some View {
    // 这里仍可继续用 some View；没必要事事 AnyView。
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      Text(bodyText)
        .foregroundStyle(.secondary)
    }
    .padding(14)
    .background(Color.primary.opacity(0.04))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  // 顶部标签。
  private func badge(_ text: String) -> some View {
    // 小标签保持普通 some View 即可。
    Text(text)
      .font(.caption.weight(.medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color.primary.opacity(0.06))
      .clipShape(Capsule())
  }
}
