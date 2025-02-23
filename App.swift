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

extension App {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
