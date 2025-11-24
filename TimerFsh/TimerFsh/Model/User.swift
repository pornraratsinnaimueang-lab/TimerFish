//
//  User.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: username) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, username: ("Nikita Sin"), email: "nikitasin@gmail.com")
}
