import Foundation

// The view model is responsible for transforming the model information into values that can be displayed on the view.
final class PinningListViewModel: ObservableObject {

    private let pinningRepository: PinningRepository

    let items: [PinningTypeData] = PinningType.allCases.map { type in
        PinningTypeData(type: type, description: "https://api.nasa.gov")
    }

    @Published private(set) var uiState: UIState = .loading

    init(pinningRepository: PinningRepository) {
        self.pinningRepository = pinningRepository
        self.uiState = .loaded
    }
    
    // MARK: - PinningListViewModelInput
    func cancelLoading() {
        uiState = .loaded
    }

    func didSelectPinningType(type: PinningType) {
        uiState = .loading
        Task {
            let value = await pinningRepository.checkPinning(type: type).value
            DispatchQueue.main.async {[weak self] in
                self?.uiState = .completion(message: value)
            }
        }
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
    case completion(message: String)
}
