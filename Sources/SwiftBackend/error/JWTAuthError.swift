//
//  JWTAuthError.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 9/20/25.
//

import Vapor
import JWTKit

enum JWTAuthError: AbortError {
    case tokenVerificationFailed
    
    var status: HTTPResponseStatus {
        return .unauthorized
    }
    
    var reason: String {
        switch self {
        case .tokenVerificationFailed:
            return "Token verification failed. The token is invalid or the signature could not be verified."
        }
    }
}
