import SwiftUI
import TipKit

@main
struct MyApp: App {
    init() {
        if #available(iOS 17.0, *) {
            try? Tips.configure()
        }
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
