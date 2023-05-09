import Foundation


/// A class that manages the API service with certificate pinning.
class NetworkManager {

    private var urlSessionDelegate: URLSessionDelegate?
    private let url: URL
    private var session: URLSession
    
    init(url: URL) {
        self.url = url
        self.session = URLSession(configuration: .ephemeral)
    }
    
    func setURLSessionDelegate(urlSessionDelegate: URLSessionDelegate?) {
        self.urlSessionDelegate = urlSessionDelegate
        session = URLSession(configuration: .ephemeral)
    }

    /// Function to fetch data from the URL
    /// - Returns: Data
    func fetchAsync() async throws -> Result<Data, Error> {
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
            return .success(data)
        } else {
            return .failure(NSError(domain: "NetworkManager", code: 0, userInfo: nil))
        }
    }
}

/// URLSessionDelegate implementation for SSL Pinning
final class URLPinningSession: NSObject, URLSessionDelegate {
    
    private var pinningStrategy: PinningProtocol
    
    init(pinningStrategy: PinningProtocol) {
        self.pinningStrategy = pinningStrategy
    }

   func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
         // Check if the challenge is for server trust
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
                let serverTrust: SecTrust = challenge.protectionSpace.serverTrust else {
            // If not, cancel the challenge
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Create a policy for SSL with the host name
        let policy: SecPolicy = SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString)
        // Set the policy for the trust
        SecTrustSetPolicies(serverTrust, policy)
        guard SecTrustEvaluateWithError(serverTrust, nil) else {
            // If not, cancel the challenge
            completionHandler(.cancelAuthenticationChallenge, nil)
           return
        }
        // Perform pinning using Pinning Strategy
        let result: Bool = pinningStrategy.performPinning(for: serverTrust)
        // Check the result
        result ? completionHandler(.useCredential, URLCredential(trust: serverTrust)) : completionHandler(.cancelAuthenticationChallenge, nil)
   }
    
}
