//
//  KeyGenerator.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/8/25.
//

import Foundation
import CryptoKit

final class KeyGenerator: Sendable {
    private static let fixedKeyBytes: [UInt8] = [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
            0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10,
            0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe,
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01
        ]
    /**
        Generates a new, cryptographically secure symmetric key.
     */
    
    static func getInstance() -> Data {
        let keyData = Data(fixedKeyBytes)
        return keyData
    }
}
