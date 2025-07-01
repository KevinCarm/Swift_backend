//
//  role.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/28/25.
//

import Fluent
import Vapor

final class Role: Model, @unchecked Sendable, Content {
    static let schema: String = "ROLES"

    @ID(custom: "ROLE_ID", generatedBy: .random)
    var id: UUID?
    
    @Field(key: "NAME")
    var name: String
    
    @Siblings(through: UserRoles.self, from: \.$role, to: \.$user)
    public var users: [User]
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        //Default constructor
    }
}
