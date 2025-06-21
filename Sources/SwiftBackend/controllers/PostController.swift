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
        return Post()
    }
}
