import Foundation

final class PinningRepository {

    private let networkManager: NetworkManager
    private let appConfiguration: AppConfiguration
    private var urlPinningSession: URLPinningSession? = nil
    
    init(
        appConfiguration: AppConfiguration
    ) {
        self.appConfiguration = appConfiguration
        self.networkManager = NetworkManager(url: URL(string: appConfiguration.apiBaseURL)!)
    }

    func checkPinning(type pinningType: PinningType) -> Task<String, Never> {
        
       switch pinningType {
        case .certificatePinning:
           urlPinningSession = URLPinningSession(pinningStrategy: CertificatePinningManager(secCertificateData: appConfiguration.certificateData))
        case .publicKeyPinning:
           urlPinningSession = URLPinningSession(pinningStrategy: PublicKeyPinningManager(pinniedKey: appConfiguration.publicKey))
        case .identityKeyPinning:
           urlPinningSession = nil
        }
        networkManager.setURLSessionDelegate(urlSessionDelegate: urlPinningSession)
       return Task {
            do {
                let result = try await networkManager.fetchAsync()
                switch result {
                case .success(let data):
                    return "Pinning Successful: \(String(data: data, encoding: .utf8) ?? "")"
                case .failure(let error):
                    return "Error: \(error)"
                }
            } catch {
                return "Error: \(error)"
            }
        }
    }

}

