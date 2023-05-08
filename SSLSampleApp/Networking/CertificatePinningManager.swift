import Foundation

/// A class that performs certificate pinning for a server trust.
class CertificatePinningManager: PinningProtocol {
    
    private let secCertificateData: CFData

    init(secCertificate: SecCertificate) {
        self.secCertificateData = SecCertificateCopyData(secCertificate)
    }

    /// Performs certificate pinning for a given server trust and pinned certificates.
    /// - Parameters:
    ///   - serverTrust: The server trust to validate.
    ///   - pinnedCertificates: The pinned certificates to compare with. Defaults to all the certificates in the app bundle.
    /// - Returns: A boolean value indicating whether the pinning was successful or not.
    private func performCertificatePinning(for serverTrust: SecTrust) -> Bool {
           
        print("Chain of certificates in server trust = \(SecTrustGetCertificateCount(serverTrust))")

        for index in 0..<SecTrustGetCertificateCount(serverTrust){
            if let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                    
                // Evaluate the server trust and get a boolean value
                let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
                let remoteCertificateData  =  SecCertificateCopyData(certificate)
                print(certificate)
                // Check if the server is trusted and the certificate data is in the pinned certificates
                if isServerTrusted && remoteCertificateData == secCertificateData {
                    print("Matched remote certificate = \(certificate)")
                    return true
                }
            }
        }
        return false
    }

    func performPinning(for serverTrust: SecTrust) -> Bool {
        return performCertificatePinning(for: serverTrust)
    }

}

