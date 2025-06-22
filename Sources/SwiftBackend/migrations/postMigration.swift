//
//  postMigration.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/21/25.
//

import Fluent
import Vapor

struct PostMigration: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws{
        try await database
            .schema("POST")
            .id()
            .field("TITLE", .string, .required)
            .field("DESCRIPTION", .string, .required)
            .field("POST_DATE", .date, .required)
            .field("USER_ID", .uuid, .required, .references("USER", "ID"))
            .create()
    }

    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("POST").delete()
    }
}
