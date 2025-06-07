import Vapor

func routes(_ app: Application) throws {
    app.post("user") { req async throws -> User in
        try User.validate(content: req)
        let input: User = try req.content.decode(User.self)
        try await input.create(on: req.db)
        return input
    }
}
