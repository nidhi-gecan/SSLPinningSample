import Foundation

enum NasaCertificateType: String, CaseIterable {
    // The raw values of the enum cases should match the file names of the certificates in the bundle
    case r31 = "R31" // or "nasaleaf" or "nasaroot"
    
    // A method that returns the data of the certificate file with a given extension
    func getCertificateData(fileExtension: String = "cer") -> Data? {
        guard let filePath = Bundle.main.path(forResource: self.rawValue, ofType: fileExtension),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                  return nil
              }
        return data
    }

    // A method that returns a SecCertificate object from the certificate data with a given extension
    func createSecCertificate(fileExtension: String = "cer") -> SecCertificate? {
        guard let data = getCertificateData(fileExtension: fileExtension),
              let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
                  return nil
              }
        return certificate
    }
}
