import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) async throws {
    // register routes
    try routes(app)
    //These lines are only for development purpose only
    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    tlsConfig.trustRoots = .none
    tlsConfig.certificateVerification = .none
    //database connection
    app.databases.use(.mysql(
        hostname: "localhost",
        username: "root",
        password: "12345678",
        database: "SWIFT_BACKEND",
        tlsConfiguration: tlsConfig
    ), as: .mysql)
    
    app.migrations.add(UserMigration())
    app.migrations.add(PostMigration())
    app.migrations.add(RoleMigration())
    app.migrations.add(UserRoleMigration())
}
