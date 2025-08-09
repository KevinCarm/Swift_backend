import Vapor
import Fluent
import FluentMySQLDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    //Add JWT
    await app.jwt.keys.add(hmac: "secret", digestAlgorithm: .sha256)
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
    
    if app.environment == .testing {
        app.databases.use(.mysql(
            hostname: "localhost",
            username: "root",
            password: "12345678",
            database: "SWIFT_BACKEND_TEST",
            tlsConfiguration: tlsConfig
        ), as: .mysql)
    }
    
    app.migrations.add(UserMigration())
    app.migrations.add(PostMigration())
    app.migrations.add(RoleMigration())
    app.migrations.add(UserRoleMigration())
}
