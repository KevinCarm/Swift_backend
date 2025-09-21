//
//  UserController.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/8/25.
//

import Vapor
import Fluent
import JWT

struct UserController {
    /**
            Create a new user
     */
    func create(req: Request) async throws -> User {
        //TODO: Validate if the input email already exists
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        
        input.password = try EncriyptionUtil.encrypData(using: input.password)!
        
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
    
    /**
        Validate the input email and password
     */
    func login(req: Request) async throws -> [String: String] {
        let input: Login = try req.content.decode(Login.self)
        let foundUser: User? = try await User.query(on: req.db)
            .filter(\.$email == input.email)
            .with(\.$roles)
            .first()
        
        if foundUser == nil {
            throw Abort(.notFound)
        }
        
        let encryptedPassword: String = foundUser!.password
        let encrypInputPassword: String = try EncriyptionUtil.encrypData(
            using: input.password
        )!
        
        if encryptedPassword != encrypInputPassword {
            throw Abort(.badRequest, reason: "email or password incorrect")
        }
        
        let roles: [Role] = foundUser!.roles
        let subject: String = foundUser!.name
        let payloadSign = PayloadSign(
            subject: SubjectClaim(value: subject),
            expiration: .init(value: .distantFuture),
            role: roles[0].name
        )
        
        return try await ["token": req.jwt.sign(payloadSign)]
    }
    
    func testToken(req: Request) async throws -> String {
        let payload = try req.auth.require(PayloadSign.self)
        
        return "Hello Swift"
    }
}
