@testable import SwiftBackend
import VaporTesting
import Testing
import FluentMySQLDriver

@Suite("App Tests",. serialized) struct SwiftBackendTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing) // Using `Application.make` for async init
        do {
            try await configure(app) // Your application's configure function
            try await test(app)
        }
        catch {
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    @Test("Create User Test") func executeCreateUserTest() async throws {
        let user: User = User(
            name: "Kevin",
            lastName: "Carmona",
            email: "kevin@email.com",
            password: "Huawei12"
        )
        try await withApp { app in
            try await app.testing().test(.POST, "user", beforeRequest: { req in
                try req.content.encode(user)
            }, afterResponse: { res async throws in
                let responseUser: User = try res.content.decode(User.self)
                #expect(res.status == .ok)
                #expect(responseUser.name == "Kevin")
            })
        }
    }
    
    @Test("Login Test") func executeLoginTest() async throws {
        let login: Login = Login(email: "kevin@email.com", password: "Huawei12")
        try await withApp { app in
            try await app.testing().test(.POST, "login", beforeRequest: { req in
                    try req.content.encode(login)
                }, afterResponse: { res in
                    let responseLogin: [String: String] = try res.content.decode([String: String].self)
                    #expect(res.status == .ok)
                    #expect(responseLogin["token"] != "")
            })
        }
    }
}
