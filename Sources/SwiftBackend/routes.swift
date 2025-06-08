import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.post("user") { req async throws -> User in
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        try await input.create(on: req.db)
        return input
    }
    app.get("user", ":id") { req async throws -> User in
        let id: String = req.parameters.get("id")!
        guard let foundUser = try await User.find(Int(id), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return foundUser
    }
}
