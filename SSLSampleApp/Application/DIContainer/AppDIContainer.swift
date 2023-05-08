import Foundation

final class AppDIContainer {
    
    // MARK: - Properties
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - View Models
    
    func makePinningViewModel() -> PinningListViewModel {
        return PinningListViewModel()
    }
}
