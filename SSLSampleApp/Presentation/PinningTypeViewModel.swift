import Foundation

// Actions are closures that are passed to the view model to be called when certain events occur.
struct PinningListViewModelActions {
    let showPinningTypes: ([String]) -> Void
}

protocol PinningListViewModelInput {
    func loadList()
    func cancelLoading()
    func didSelectPinningType(type: PinningType)
}

// The view model is responsible for transforming the model information into values that can be displayed on the view.
final class PinningListViewModel: ObservableObject, PinningListViewModelInput {
    
    private let actions: PinningListViewModelActions?
    
    @Published private(set) var items: [PinningTypeData] = PinningType.allCases.map { type in
        PinningTypeData(type: type, description: "https://api.nasa.gov")
    }

    @Published private(set) var uiState: UIState = .loading

    init(actions: PinningListViewModelActions? = nil) {
        self.actions = actions
        self.uiState = .loaded
    }
    
    // MARK: - PinningListViewModelInput
    func loadList() {
        uiState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.uiState = .error
        }
    }
    
    func cancelLoading() {
        uiState = .loaded
    }

    func didSelectPinningType(type: PinningType) {
        loadList()
       // actions?.showPinningTypes(["https://api.nasa.gov"])
    }

}

// The model is responsible for storing pinning type information.
struct PinningTypeData: Identifiable {
    var id: UUID = UUID()
    let type: PinningType
    let description: String
}

enum UIState {
    case loading
    case loaded
    case error
}
