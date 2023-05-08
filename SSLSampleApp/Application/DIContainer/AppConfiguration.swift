import Foundation

final class AppConfiguration {
    
    // MARK: - Properties
    private let certificateFileName: String = "R31"
    private let certificateFileExtension: String = "cer"
    private let apiBaseUrlKey: String = "API_BASE_URL"
    private let apiDicKey: String = "PUBLIC_KEY"

    lazy var apiBaseURL: String = {
        guard let apiBaseURL: String = Bundle.main.object(forInfoDictionaryKey: apiBaseUrlKey) as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var publicKey: String = {
        guard let apiKey: String = Bundle.main.object(forInfoDictionaryKey: apiDicKey) as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()

    private lazy var certificateData: Data = {
        guard let filePath: String = Bundle.main.path(forResource: certificateFileName, ofType: certificateFileExtension),
              let data: Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                fatalError("Certificate file not found")
              }
        return data
    }()

    lazy var secCertificate: SecCertificate = {
        guard let secCertificate: SecCertificate = SecCertificateCreateWithData(nil, certificateData as CFData) else {
            fatalError("SecCertificate could not be created")
        }
        return secCertificate
    }()
    
    // MARK: - Initializers
    
    init() { }
}
