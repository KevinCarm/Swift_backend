//
//  userrRoleMigration.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/28/25.
//

import Fluent

struct UserRoleMigration: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("USER_ROLES")
            .id()
            .field(
                "ROLE_ID",
                .uuid,
                .required,
                .references("ROLES", "ROLE_ID", onDelete: .cascade)
            )
            .field(
                "USER_ID",
                .uuid,
                .required,
                .references("USER", "USER_ID", onDelete: .cascade)
            )
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("USER_ROLES").delete()
    }
}
