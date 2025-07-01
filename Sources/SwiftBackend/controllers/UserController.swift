//
//  UserController.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/8/25.
//

import Vapor
import Fluent

struct UserController {
    /**
            Create a new user
     */
    func create(req: Request) async throws -> User {
        //TODO: Validate if the input email already exists
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        
        input.password = try EncriyptionUtil.encrypData(
            plainText: input.password,
            using: KeyGenerator.getInstance()
        ).base64EncodedString()
        
        try await input.create(on: req.db)
        if let userRole = try await Role.query(on: req.db).filter(\.$name == "user").first() {
            try await input.$roles.attach(userRole, on: req.db)
        }
        input.password = ""
        return input
    }
    /**
            Get user by id
     */
    func getById(req: Request) async throws -> User {
        let id = req.parameters.get("id", as: UUID.self)!
        guard let foundUser = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        foundUser.password = ""
        return foundUser
    }
    /**
            Update a user by id
     */
    func update(req: Request) async throws -> User {
        let newUser: User = try req.content.decode(User.self)
        guard let foundUser = try await User.find(newUser.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        foundUser.name = newUser.name
        foundUser.lastName = newUser.lastName
        foundUser.email = newUser.email
        try await foundUser.update(on: req.db)
        newUser.password = ""
        return newUser
    }
    /**
        Delete user by id
     */
    func delete(req: Request) async throws -> String {
        let id = req.parameters.get("id", as: UUID.self)!
        guard let foundUser = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        try await foundUser.delete(on: req.db)
        return "User deleted successfully"
    }
    
    func login(req: Request) async throws -> [Role] {
        let input = try req.content.decode(Login.self)
        let foundUser = try await User.query(on: req.db)
            .filter(\.$email == input.email)
            .with(\.$roles)
            .first()
        if foundUser == nil {
            throw Abort(.notFound)
        }
        let roles = try await foundUser!.$roles.query(on: req.db).all()
       
        return roles
    }
}
