import SwiftUI

@main
struct SSLSampleApp: App {
    private let appDIContainer: AppDIContainer = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appDIContainer.makePinningViewModel())
        }
    }
}
