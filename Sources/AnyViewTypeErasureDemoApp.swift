import SwiftUI

// 这是 demo 的应用入口。
@main
struct AnyViewTypeErasureDemoApp: App {
  // 定义主窗口。
  var body: some Scene {
    // 用单窗口承载 demo。
    Window("AnyView Demo", id: "main") {
      // 展示主界面。
      ContentView()
    }
    // 给窗口 1 个舒服尺寸。
    .defaultSize(width: 1240, height: 860)
  }
}
