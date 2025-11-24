//
//  AuthViewModel.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import SwiftUI
import Combine
import FirebaseAuth
import Firebase
import FirebaseFirestore

protocol AuthenticationFormProtocal {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?   // เก็บผู้ใช้งานปัจจุบัน
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withemail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("Debug: failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, username: username, email: email)
            let userData = user.toDictionary()
            
            try await Firestore.firestore()
                .collection("users")
                .document(result.user.uid)
                .setData(userData)
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        //  delete account
    }
}
