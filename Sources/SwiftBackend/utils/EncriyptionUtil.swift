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
    /**
        Encryp string data
     */
    static func encrypData(plainText: String, using key: SymmetricKey) throws -> Data {
        guard let data = plainText.data(using: .utf8) else {
            throw EncryptionError.encryptionFailed
        }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined!
        } catch {
            throw EncryptionError.encryptionFailed
        }
    }
    static func decrypData(encrypData: String, using key: SymmetricKey) throws -> String {
        do {
            let data = Data(base64Encoded: encrypData)
            let sealedBox = try AES.GCM.SealedBox(combined: data!)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            
            guard let decryptedString = String(
                data: decryptedData,
                encoding: .utf8
            ) else {
                throw EncryptionError.decryptionFailed
            }
            return decryptedString
        } catch {
            throw EncryptionError.decryptionFailed
        }
    }
}
