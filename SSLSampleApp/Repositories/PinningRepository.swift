import Foundation

final class PinningRepository {

    private let networkManager: NetworkManager
    private let urlSession: URLPinningSession
    private let appConfiguration: AppConfiguration
    
    init(
        appConfiguration: AppConfiguration,
        urlSession: URLPinningSession
    ) {
        self.appConfiguration = appConfiguration
        self.urlSession = urlSession
        self.networkManager = NetworkManager(url: URL(string: appConfiguration.apiBaseURL)!, urlSessionDelegate: urlSession)
    }

    func checkPinning(type pinningType: PinningType) -> Task<String, Never> {
        
       switch pinningType {
         case .certificatePinning:
           urlSession.changePinningStrategy(to: CertificatePinningManager(secCertificateData: appConfiguration.certificateData))
        case .publicKeyPinning:
           urlSession.changePinningStrategy(to: PublicKeyPinningManager(pinniedKey: appConfiguration.publicKey))
       }
        
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
