import Foundation

enum PinningType: String, CaseIterable {
    case certificatePinning = "Certificate Pinning"
    case publicKeyPinning = "Public Key Pinning"
    case identityKeyPinning = "Identity Key Pinning"
}

