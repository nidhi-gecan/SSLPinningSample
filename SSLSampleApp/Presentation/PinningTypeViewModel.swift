import Foundation

protocol PinningListViewModelInput {
    func cancelLoading()
    func didSelectPinningType(type: PinningType)
}

// The view model is responsible for transforming the model information into values that can be displayed on the view.
final class PinningListViewModel: ObservableObject, PinningListViewModelInput {

    private let pinningRepository: PinningRepository

    @Published private(set) var items: [PinningTypeData] = PinningType.allCases.map { type in
        PinningTypeData(type: type, description: "https://api.nasa.gov")
    }

    @Published private(set) var uiState: UIState = .loading

    init(pinningRepository: PinningRepository) {
        self.pinningRepository = pinningRepository
        self.uiState = .loaded
    }
    
    // MARK: - PinningListViewModelInput
    func cancelLoading() {
        uiState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.uiState = .loaded
        }
    }

    func didSelectPinningType(type: PinningType) {
        uiState = .loading
        Task {
            let value = await pinningRepository.checkPinning(type: type).value
            DispatchQueue.main.async {[weak self] in
                self?.uiState = .error(message: value)
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
    case error(message: String)
}
