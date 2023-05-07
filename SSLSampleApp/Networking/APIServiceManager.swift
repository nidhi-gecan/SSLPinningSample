//
//  APIServiceManager.swift
//  Certificate_Pinning_Demo
//
//

import Foundation
import Security
import CommonCrypto

/// A class that manages the API service with certificate pinning.
class APIServiceManager: NSObject {

    // A shared instance of the class.
    static let shared = APIServiceManager()

    // The type of certificate pinning to use.
    private var pinningType: CertificatePinningType = .publicKeyPinning
    
    private override init() {
        super.init()
    }

    /// Calls an API with a given URL and pinning type, and returns a completion handler with a message.
    /// - Parameters:
    ///   - url: The URL of the API to call.
    ///   - pinningType: The type of certificate pinning to use.
    ///   - completion: A closure that takes a string as an argument and returns nothing.
    func callAPI(withURL url: URL, pinningType: CertificatePinningType, completion: @escaping (String) -> Void) {
        // Create a session with ephemeral configuration and self as delegate
        let session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        self.pinningType = pinningType
        var responseMessage = ""

        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for error
            if let error = error {
                print("error: \(error.localizedDescription): \(error)")
                responseMessage = "Pinning failed"
            } else if let data = data {
                _ = String(decoding: data, as: UTF8.self)
                responseMessage = pinningType.getSuccessMessage()
            }
            
            DispatchQueue.main.async {
                completion(responseMessage)
            }
        }
        // Resume the task
        task.resume()
    }
}

/// An extension of the APIServiceManager class that conforms to the URLSessionDelegate protocol.
extension APIServiceManager: URLSessionDelegate {
    
    /// Handles the authentication challenge for the session.
    /// - Parameters:
    ///   - session: The session that received the challenge.
    ///   - challenge: The authentication challenge.
    ///   - completionHandler: A closure that takes a disposition and a credential as arguments and returns nothing.
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Check if the challenge is for server trust
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust else {
            // Cancel the challenge if not
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        // Create a policy for SSL with the host name
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        // Set the policy for the server trust
        SecTrustSetPolicies(serverTrust, policy)

        // Initialize a result flag
        var result: Bool = false
        // Perform pinning based on the pinning type
        switch pinningType {
            case .certificatePinning:
                result = CertificatePinningManager().performCertificatePinning(for: serverTrust)
            case .publicKeyPinning:
                result = PublicKeyPinningManager().performPublicKeyPinning(for: serverTrust, pinnedKeys: Constants.pinnedKeys)
        }

        // Check the result
        if result {
            // Use a credential with the server trust if successful
            let credential:URLCredential =  URLCredential(trust:serverTrust)
            completionHandler(.useCredential,credential)
        } else {
            // Cancel the challenge if failed
            completionHandler(.cancelAuthenticationChallenge,nil)
        }
    }
}
