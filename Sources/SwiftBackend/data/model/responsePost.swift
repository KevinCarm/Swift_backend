//
//  responsePost.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/22/25.
//

import Vapor

struct ResponsePost: Content {
    var id: UUID
    var title: String
    var description: String
    var postDate: Date
    
    init(id: UUID, title: String, description: String, postDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.postDate = postDate
    }
}
