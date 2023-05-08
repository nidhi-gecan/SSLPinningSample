import Foundation

protocol PinningProtocol {
    func performPinning(for serverTrust: SecTrust) -> Bool
}