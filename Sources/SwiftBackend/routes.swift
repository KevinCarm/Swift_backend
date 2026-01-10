import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    let protected = app.grouped(
        PayloadSign.authenticator(),
        PayloadSign.guardMiddleware()
    )
    app.middleware.use(CustomErrorMiddleware())
    
    let userController: UserController = UserController()
    let postController: PostController = PostController()
    /**
        User routes
     */
    app.post("user", use: userController.create)
    protected.delete("user", ":id", use: userController.delete)
    protected.put("user", use: userController.update)
    protected.get("user", ":id", use: userController.getById)
    app.post("login", use: userController.login)
    /**
        Post routes
     */
    app.post("post", use: postController.create)
    app.get("user", ":id", "post", use: postController.getAll)
    app.get("post", ":id", use: postController.getById)
}
