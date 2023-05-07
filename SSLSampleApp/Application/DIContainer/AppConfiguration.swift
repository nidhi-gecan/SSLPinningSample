import Foundation

final class AppConfiguration {
    
    // MARK: - Properties
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL: String = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    // MARK: - Initializers
    
    init() { }
}
