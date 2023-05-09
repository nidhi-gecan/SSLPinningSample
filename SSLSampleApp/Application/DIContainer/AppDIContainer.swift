import Foundation

final class AppDIContainer {
    
    // MARK: - Properties
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - View Models
    
    func makePinningViewModel() -> PinningListViewModel {
        return PinningListViewModel(
            pinningRepository: makePinningRepository()
        )
    }

    // MARK: - Repositories

    func makePinningRepository() -> PinningRepository {
        return PinningRepository(appConfiguration: appConfiguration)
    }
}
