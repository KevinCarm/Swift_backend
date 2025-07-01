//
//  user.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/1/25.
//
import Fluent
import Vapor

final class User: Model, ValidatableContent, @unchecked Sendable {
    static let schema = "USER"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "NAME")
    var name: String
    
    @Field(key: "LASTNAME")
    var lastName: String
    
    @Field(key: "EMAIL")
    var email: String
    
    @Field(key: "PASSWORD")
    var password: String
    
    @Children(for: \.$user)
    var posts: [Post]
    
    @Siblings(through: UserRoles.self, from: \.$user, to: \.$role)
    var roles: [Role]
    
    init() {
        //Default constructor
    }
    
    init(
        id: UUID? = nil,
        name: String,
        lastName: String,
        email: String,
        password: String
    ) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.id = id
        self.password = password
    }
    
    static func validations(_ validations: inout Validations)  {
        validations.add(
            "email",
            as: String.self,
            is: .email && .count(8...100),
            customFailureDescription: "Provided email is empty or does not have the correct format"
        )
        validations.add(
            "name",
            as: String.self,
            is: !.empty && .alphanumeric && .count(5...15),
            customFailureDescription: "Provided name is empty"
        )
        validations.add(
            "lastName",
            as: String.self,
            is: !.empty && .alphanumeric && .count(5...15),
            customFailureDescription: "Provided lastname is empty"
        )
        validations.add(
            "password",
            as: String.self,
            is: !.empty && .count(8...) && .pattern(".*[A-Z]+.*") &&
                .pattern(".*[a-z]+.*") &&
                .pattern(".*[0-9]+.*"),
            customFailureDescription: "Password must have at least 8 characters, one digit and one upper case letter"
        )
    }
}
