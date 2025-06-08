import Vapor
import Fluent

func routes(_ app: Application) throws {
    /**
            Create a new user
     */
    app.post("user") { req async throws -> User in
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        try await input.create(on: req.db)
        return input
    }
    /**
            Get user by id
     */
    app.get("user", ":id") { req async throws -> User in
        let id: String = req.parameters.get("id")!
        guard let foundUser = try await User.find(Int(id), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return foundUser
    }
    /**
            Update a user by id
     */
    app.put("user", ":id") { req async throws -> User in
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
