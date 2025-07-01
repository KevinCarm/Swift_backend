//
//  roleMigration.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/28/25.
//

import Fluent

struct RoleMigration: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("ROLES")
            .id()
            .field("NAME", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("ROLES").delete()
    }
}
