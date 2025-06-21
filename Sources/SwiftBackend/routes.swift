import Vapor
import Fluent

func routes(_ app: Application) throws {
    let userController: UserController = UserController()
    let postController: PostController = PostController()
    /**
        User routes
     */
    app.post("user", use: userController.create)
    app.get("user", ":id", use: userController.getById)
    app.put("user", use: userController.update)
    app.delete("user", ":id", use: userController.delete)
    /**
        Post routes
     */
    app.post("user", ":id", "post", use: postController.create)
}
