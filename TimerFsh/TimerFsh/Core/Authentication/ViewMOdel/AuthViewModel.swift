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
    @Published var currentUser: User?               // เก็บผู้ใช้งานปัจจุบัน
    
    init() {
        self.userSession = Auth.auth().currentUser
        if self.userSession != nil {
            Task { await fetchUser() }
        }
    }
    
    func signIn(withemail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Debug: failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, username: username, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            
            try await Firestore.firestore()
                .collection("users")
                .document(user.id)
                .setData(encodedUser)
                await fetchUser()
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        //  delete account
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
