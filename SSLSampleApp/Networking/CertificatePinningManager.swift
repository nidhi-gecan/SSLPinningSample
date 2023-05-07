import Foundation

/// A class that performs certificate pinning for a server trust.
class CertificatePinningManager{

    /// Gets all the pinned certificates from the app bundle.
    /// - Returns: An array of SecCertificate objects.
    static func getAllPinnedCertificates() -> [SecCertificate] {
        // Initialize an empty array of certificates
        var certificates: [SecCertificate] = []
        
        for certificateName in NasaCertificateType.allCases {
            // Get the certificate from the name
            if let certificate = certificateName.createSecCertificate() {
                certificates.append(certificate)
            }
        }
        print("Certificates in app bundle = \(certificates)")
        return certificates
    }


    /// Gets all the pinned certificate data from the app bundle.
    /// - Returns: An array of Data objects.
    static func getAllPinnedCertificateData() -> [Data] {
        // Map the certificates to their data
        return getAllPinnedCertificates().map { SecCertificateCopyData($0) as Data }
    }

    /// Performs certificate pinning for a given server trust and pinned certificates.
    /// - Parameters:
    ///   - serverTrust: The server trust to validate.
    ///   - pinnedCertificates: The pinned certificates to compare with. Defaults to all the certificates in the app bundle.
    /// - Returns: A boolean value indicating whether the pinning was successful or not.
    func performCertificatePinning(for serverTrust: SecTrust, pinnedCertificates: Set<Data> = Set(CertificatePinningManager.getAllPinnedCertificateData())) -> Bool {
           
        print("Chain of certificates in server trust = \(SecTrustGetCertificateCount(serverTrust))")

        for index in 0..<SecTrustGetCertificateCount(serverTrust){
            if let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                    
                // Evaluate the server trust and get a boolean value
                let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
                let remoteCertificateData  =  SecCertificateCopyData(certificate)
                print(certificate)
                print(pinnedCertificates)
                // Check if the server is trusted and the certificate data is in the pinned certificates
                if isServerTrusted && pinnedCertificates.contains(remoteCertificateData as Data) {
                    print("Matched remote certificate = \(certificate)")
                    return true
                }
            }
        }
        return false
    }

}

