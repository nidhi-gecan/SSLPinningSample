import Foundation

enum PinningType: String, CaseIterable {
    case certificatePinning = "Certificate Pinning"
    case publicKeyPinning = "Public Key Pinning"

    func errorMessage() -> String {
        switch self {
        case .certificatePinning:
            return "Certificate pinning failed"
        case .publicKeyPinning:
            return "Public key pinning failed"
        }
    }
}

