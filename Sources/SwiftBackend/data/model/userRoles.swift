//
//  userRoles.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/28/25.
//

import Fluent
import Vapor

final class UserRoles: Model, @unchecked Sendable {
    static let schema: String = "USER_ROLES"

    @ID(custom: "USER_ROLE_ID", generatedBy: .random)
    var id: UUID?
    
    @Parent(key: "USER_ID")
    var user: User
    
    @Parent(key: "ROLE_ID")
    var role: Role
    
    
    init() {
        //Default constructor
    }
}
