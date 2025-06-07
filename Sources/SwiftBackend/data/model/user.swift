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
    
    @ID(custom: "ID")
    var id: Int?
    
    @Field(key: "NAME")
    var name: String
    
    @Field(key: "LASTNAME")
    var lastName: String
    
    @Field(key: "EMAIL")
    var email: String
    
    init() {
        //Default constructor
    }
    
    init(id: Int? = nil, name: String, lastName: String, email: String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.id = id
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
    }
}
