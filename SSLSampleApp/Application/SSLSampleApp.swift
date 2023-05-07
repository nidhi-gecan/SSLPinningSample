import SwiftUI

@main
struct SSLSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: PinningListViewModel())
        }
    }
}
