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
        let payload = try req.auth.require(PayloadSign.self)
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
        return newPost
    }
    /**
        Get user posts
     */
    func getAll(req: Request) async throws -> [ResponsePost] {
        let userId = req.parameters.get("id", as: UUID.self)
        guard let foundUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        let posts = try await Post.query(on: req.db)
            .filter(\.$user.$id == foundUser.id!)
            .with(\.$user)
            .all()
        return posts.map { post in
            ResponsePost(
                id: post.id!,
                title: post.title,
                description: post.description!,
                postDate: post.postDate!
            )
        }
    }
    /**
        Get post by id
     */
    func getById(req: Request) async throws -> ResponsePost {
        let postId = req.parameters.get("id", as: UUID.self)
        guard let foundPost = try await Post.find(postId, on: req.db) else {
            throw Abort(.notFound)
        }
        return ResponsePost(
            id: foundPost.id!,
            title: foundPost.title,
            description: foundPost.description!,
            postDate: foundPost.postDate!
        )
    }
}
