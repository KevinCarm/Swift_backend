//
//  login.swift
//  SwiftBackend
//
//  Created by Kevin Carmona.S on 6/29/25.
//

import Vapor

struct Login: Content, ValidatableContent {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add(
            "email",
            as: String.self,
            is: .email && !.empty,
            customFailureDescription: "Email canot be empty and must be a valid email"
        )
        validations.add(
            "password",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Password cannot be empty"
        )
    }
}
