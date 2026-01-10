//
//  PostTestClass.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 1/10/26.
//

@testable import SwiftBackend
import VaporTesting
import Testing
import FluentMySQLDriver

@Suite("Post test",. serialized) struct PostTestClass {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing) // Using `Application.make` for async init
        do {
            try await configure(app) // Your application's configure function
            try await test(app)
        }
        catch {
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
     @Test("Post test example") func executeTest() {
         #expect("" == "")
    }
}
