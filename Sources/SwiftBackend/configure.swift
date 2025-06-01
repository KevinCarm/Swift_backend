import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    //database connection
    app.databases.use(.mysql(hostname: "localhost", username: "root", password: "12345678", database: "SWIFT_BACKEND"), as: .mysql)
}
