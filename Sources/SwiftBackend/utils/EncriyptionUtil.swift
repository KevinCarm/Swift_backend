//
//  EncriyptionUtil.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/8/25.
//
import Foundation
import CryptoKit


enum EncryptionError: Error {
    case encryptionFailed
    case decryptionFailed
    case invalidKey
    case invalidCiphertext
}

 class EncriyptionUtil {
     
     private static let rawKeyData: Data = KeyGenerator.getInstance()
    /**
        Encryp string data
     */
    public static func encrypData(using text: String) throws -> String? {
        let inputData = Data(text.utf8)
        let hash = SHA256.hash(data: inputData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
