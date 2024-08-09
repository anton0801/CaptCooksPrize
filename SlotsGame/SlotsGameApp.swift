import SwiftUI

@main
struct SlotsGameApp: App {
    
    @UIApplicationDelegateAdaptor(ApplicationUtils.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
