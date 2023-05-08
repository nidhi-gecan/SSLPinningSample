import Foundation

/// A class that performs certificate pinning for a server trust.
class CertificatePinningManager: PinningProtocol {
    
    private let secCertificateData: Data

    init(secCertificateData: Data) {
        self.secCertificateData = secCertificateData
    }

    /// Performs certificate pinning for a given server trust and pinned certificates.
    /// - Parameters:
    ///   - serverTrust: The server trust to validate.
    ///   - pinnedCertificates: The pinned certificates to compare with. Defaults to all the certificates in the app bundle.
    /// - Returns: A boolean value indicating whether the pinning was successful or not.
    private func performCertificatePinning(for serverTrust: SecTrust) -> Bool {
        
        var result: Bool = false
           
        print("Chain of certificates in server trust = \(SecTrustGetCertificateCount(serverTrust))")
        
        guard let secTrusts: [SecCertificate] = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            return false
        }

        secTrusts.map { SecCertificateCopyData($0) as Data }.forEach { 
            if $0 == secCertificateData {
                print("Matched remote certificate = \($0)")
                result = true
            }
         }
    
        return result
    }

    func performPinning(for serverTrust: SecTrust) -> Bool {
        return performCertificatePinning(for: serverTrust)
    }

}

