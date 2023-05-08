//
//  PublicKeyPinningManager.swift
//  Certificate_Pinning_Demo
//

import Foundation
import Security
import CommonCrypto
import CryptoKit

class PublicKeyPinningManager: PinningProtocol {
    
    private let pinnedKey: String
    
    init(pinniedKey: String) {
        self.pinnedKey = pinniedKey
    }
    
    // A constant array of bytes that represents the ASN.1 header for RSA 2048 public keys
    private let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    // A method that returns the SHA256 hash of a given data as a base64 encoded string
    private func sha256(data: Data) -> String {
        // Prepend the ASN.1 header to the data
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        // Use the native SHA256 implementation if available
        if #available(iOS 13, *) {
            return Data(SHA256.hash(data: keyWithHeader)).base64EncodedString()
        } else {
            // Use the CommonCrypto library otherwise
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            keyWithHeader.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress!, CC_LONG(keyWithHeader.count), &hash)
            }
            return Data(hash).base64EncodedString()
        }
    }

    // A method that performs public key pinning for a given server trust and an array of pinned keys
    private func performPublicKeyPinning(for serverTrust: SecTrust) -> Bool {
        
        guard let secCertificates: [SecCertificate] = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            return false
        }
        
        for secCertificate: SecCertificate in secCertificates {
            // Get the public key data from the certificate
            guard let publicKey: SecKey = SecCertificateCopyKey(secCertificate),
            let publicKeyData: CFData = SecKeyCopyExternalRepresentation(publicKey, nil) else {
                return false
            }
            // Compute the hash of the public key data
            let keyHash: String = sha256(data: publicKeyData as Data)
            print("Server Hashed Key = \(keyHash)")
            // Check if the hash matches any of the pinned keys
            if pinnedKey == keyHash {
                return true
            }
        }
        // Return false if none of the hashes match
        return false
    }

    func performPinning(for serverTrust: SecTrust) -> Bool {
        // Perform public key pinning
        return performPublicKeyPinning(for: serverTrust)
    }
}
