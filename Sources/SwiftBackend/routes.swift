import Vapor
import Fluent

func routes(_ app: Application) throws {
    let userController: UserController = UserController()
    /**
        User routes
     */
    app.post("user", use: userController.create)
    app.get("user", ":id", use: userController.getById)
    app.put("user", ":id", use: userController.update)
}
