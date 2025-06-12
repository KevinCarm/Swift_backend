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
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        
        let password: String = try EncriyptionUtil.encrypData(
            plainText: input.password,
            using: KeyGenerator.getInstance()
        ).base64EncodedString()
        input.password = password
        
        try await input.create(on: req.db)
        return input
    }
    /**
            Get user by id
     */
    func getById(req: Request) async throws -> User {
        let id: String = req.parameters.get("id")!
        guard let foundUser = try await User.find(Int(id), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        foundUser.password = ""
        return foundUser
    }
    /**
            Update a user by id
     */
    func update(req: Request) async throws -> User {
        let id: String = req.parameters.get("id")!
        guard let foundUser = try await User.find(Int(id), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        let newUser: User = try req.content.decode(User.self)
        foundUser.name = newUser.name
        foundUser.lastName = newUser.lastName
        foundUser.email = newUser.email
        try await foundUser.update(on: req.db)
        return newUser
    }
}
