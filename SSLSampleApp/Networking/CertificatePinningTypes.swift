//
//  CertificatePinningTypes.swift
//  Certificate_Pinning_Demo
//
//  Created by Nidhi Gupta on 05/05/23.
//

import Foundation

/// An enum that represents the type of certificate pinning.
enum CertificatePinningType: Int {
    // The type of certificate pinning that uses the whole certificate data.
    case certificatePinning
    // The type of certificate pinning that uses only the public key data.
    case publicKeyPinning

    /// Gets a success message for the pinning type.
    /// - Returns: A string that indicates the completion of pinning.
    func getSuccessMessage() -> String {
        switch self {
            case .certificatePinning:
                return "Certificate pinning is completed successfully."
            case .publicKeyPinning:
                return "Public Key pinning is completed successfully."
        }
    }
}

