//
//  Constants.swift
//  Certificate_Pinning_Demo
//
//  Created by Nidhi Gupta on 05/05/23.
//

import Foundation

/// A struct that contains constants for the pinning process.
struct Constants {
    
    // An array of base64 encoded public keys that are used for pinning.
    static let pinnedKeys:[String] = ["MBkXnNdQr3VwQ96iMtsitNL9ZxXliZW+7X9qdxH4HNs="]

    // A dictionary of domain names and their corresponding URLs that are used for pinning.
    static let pinnedWeb = ["Nasa.com": "https://api.nasa.gov"]
}

