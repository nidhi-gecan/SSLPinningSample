import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: PinningListViewModel
    
    init(viewModel: PinningListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView().progressViewStyle(.circular)
            case .loaded:
                List(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.type.rawValue)
                            .font(.headline)
                            .onTapGesture {
                                self.viewModel.didSelectPinningType(type: item.type)
                            }
                        Text(item.description)
                            .font(.subheadline)
                    }
                }
            case .error(let message):
            ErrorView(message: message) {
                viewModel.cancelLoading()
            }

        }
        
    }
}

struct ErrorView: View {

    var message: String
    var cancel: () -> Void
    
    init(message: String, cancel: @escaping () -> Void) {
        self.message = message
        self.cancel = cancel
    }
    
    var body: some View {
        VStack {
            Text(message).font(.caption)
            Button("Go Back") {
                cancel()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Your message goes here!!") {
            // Do nothing
        }
    }
}
