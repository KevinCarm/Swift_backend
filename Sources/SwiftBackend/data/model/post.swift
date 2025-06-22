//
//  post.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/12/25.
//
import Fluent
import Vapor

final class Post: Model, ValidatableContent, @unchecked Sendable {
    static let schema = "POST"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "TITLE")
    var title: String
    
    @Field(key: "DESCRIPTION")
    var description: String?
    
    @Field(key: "POST_DATE")
    var postDate: Date?
    
    @Parent(key: "USER_ID")
    var user: User
    
    init() {
        //Default constructor
        self.postDate = Date()
    }
    
    init(
        id: UUID? = nil,
        title: String,
        description: String? = nil,
        userId: UUID
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.postDate = Date()
        self.$user.id = userId
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add(
            "title",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Title can not be empty"
        )
        validations.add(
            "description",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Description can not be empty"
        )
    }
}
