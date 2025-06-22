//
//  PostController.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/12/25.
//
import Fluent
import Vapor

struct PostController {
    /**
        Create a new post
     */
    func create(req: Request) async throws -> Post {
        try Post.validate(content: req)
        let post = try req.content.decode(Post.self)
        let userId = post.$user.id
        guard let foundUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        let newPost: Post = Post(
            title: post.title,
            description: post.description,
            userId: foundUser.id!
        )
        try await newPost.save(on: req.db)
        return post
    }
}
