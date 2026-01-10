@testable import SwiftBackend
import VaporTesting
import Testing
import FluentMySQLDriver

@Suite("User test",. serialized) struct UserTestClass {
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
        
        let milliseconds = Int64(Date().timeIntervalSince1970 * 1000)
        let name = "Kevin\(Int.random(in: 1...20))"
        let lastName = "Carmona\(Int.random(in: 1...20))"
        
        let user: User = User(
            name: name,
            lastName: lastName,
            email: "kevin\(milliseconds)@email.com",
            password: "Huawei12"
        )
        try await withApp { app in
            try await app.testing().test(.POST, "user", beforeRequest: { req in
                try req.content.encode(user)
            }, afterResponse: { res async throws in
                let responseUser: User = try res.content.decode(User.self)
                #expect(res.status == .ok)
                #expect(responseUser.name == name)
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
    
    @Test("Get user by id test") func executeGetUserByIdTest() async throws {
        let login: Login = Login(email: "kevin@email.com", password: "Huawei12")
        try await withApp { app in
            try await app.testing().test(.POST, "login", beforeRequest: { req in
                try req.content.encode(login)
            }, afterResponse: { res in
                let responseLogin: [String: String] = try res.content.decode([String: String].self)
                #expect(res.status == .ok)
                #expect(responseLogin["token"] != "")
                #expect(responseLogin["user"] != "")
                
                let userId: String = responseLogin["user"]!
                let token: String = responseLogin["token"]!
                try await app.testing().test(.GET, "user/\(userId)", beforeRequest: { req in
                        req.headers.bearerAuthorization = .init(token: token)
                }, afterResponse: { res in
                    let user: User = try res.content.decode(User.self)
                    let roles = try await Role.query(on: app.db)
                        .join(UserRoles.self, on: \Role.$id == \UserRoles.$role.$id)
                        .filter(UserRoles.self, \.$user.$id == user.requireID())
                        .all()
                    #expect(user.id != nil)
                    #expect(user.name != "")
                    #expect(user.email != "")
                    #expect(user.lastName != "")
                    #expect(roles.isEmpty == false)
                })
            })
        }
    }
}
