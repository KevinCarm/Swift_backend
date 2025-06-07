@testable import SwiftBackend
import VaporTesting
import Testing

@Suite("App Tests",. serialized)
struct SwiftBackendTests {
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
   @Test
    func executeGetAllUsersTest() async throws {
        try await self.withApp { app in
            try await app
                .testing()
                .test(.GET, "hello") { res async in
                    #expect(res.status == .ok)
                }
        }
    }
}
