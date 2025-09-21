//
//  CustomErrorMiddleware.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 9/20/25.
//

import Vapor
import JWTKit

final class CustomErrorMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch _ as JWTKit.JWTError {
            throw JWTAuthError.tokenVerificationFailed
        } catch {
            throw error
        }
    }
}
