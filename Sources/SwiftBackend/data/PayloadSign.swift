//
//  PayloadSign.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 7/17/25.
//

import JWT
import Vapor

struct PayloadSign: JWTPayload, Authenticatable {
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case role = "role"
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var role: String
    
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }    
}
