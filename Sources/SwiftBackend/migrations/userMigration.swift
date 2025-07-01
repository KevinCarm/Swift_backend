//
//  userMigration.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/20/25.
//

import Fluent
import Vapor

struct UserMigration: AsyncMigration {
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("USER").delete()
    }

    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("USER")
            .id()
            .field("NAME", .string, .required)
            .field("LAST_NAME", .string, .required)
            .field("EMAIL", .string, .required)
            .field("PASSWORD", .string, .required)
            .unique(on: "email")
            .create()
    }
}
