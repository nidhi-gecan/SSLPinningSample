import Foundation

// Actions are closures that are passed to the view model to be called when certain events occur.
struct PinningListViewModelActions {
    let showPinningTypes: ([String]) -> Void
}

// The view model is responsible for transforming the model information into values that can be displayed on the view.
final class PinningListViewModel: ObservableObject {
    
    private let actions: PinningListViewModelActions?
    
    @Published private(set) var items: [PinningTypeData] = PinningType.allCases.map { type in
        PinningTypeData(type: type, description: "https://api.nasa.gov")
    }

    init(actions: PinningListViewModelActions? = nil) {
        self.actions = actions
    }
}

// The model is responsible for storing pinning type information.
struct PinningTypeData: Identifiable {
    var id: UUID = UUID()
    let type: PinningType
    let description: String
}
