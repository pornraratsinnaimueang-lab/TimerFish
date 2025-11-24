//
//  UserService.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class UserService: ObservableObject {
    @Published var currentUser: User?
    
    private var firestoreListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    init(authViewModel: AuthViewModel) {
        // This service listens to the user session from the AuthViewModel
        authViewModel.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] firebaseUser in
                guard let self = self else { return }
                if let uid = firebaseUser?.uid {
                    // If a user is logged in, attach a real-time listener.
                    self.attachFirestoreListener(for: uid)
                } else {
                    // If the user logs out, remove the listener and clear the user data.
                    self.firestoreListener?.remove()
                    self.currentUser = nil
                    print("Firestore listener removed and user data cleared.")
                }
            }
            .store(in: &cancellables)
    }

    private func attachFirestoreListener(for uid: String) {
        // Prevent attaching multiple listeners.
        firestoreListener?.remove()

        let userDocRef = Firestore.firestore().collection("users").document(uid)
        
        firestoreListener = userDocRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error listening to user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, let data = document.data() else {
                print("User document not found or is empty.")
                return
            }
            
            self.currentUser = User(id: document.documentID, data: data)
            print("User data updated locally from Firestore snapshot.")
        }
    }
    
    /// Updates the user's aquarium layout in Firestore.
    func updateAquariumLayout(layout: [[String: Any]]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            // In a real app, throw an error
            print("User not authenticated.")
            return
        }
        
        let userDocRef = Firestore.firestore().collection("users").document(uid)
        try await userDocRef.updateData(["aquariumLayout": layout])
        print("Aquarium layout successfully updated in Firestore.")
    }
}

// MARK: - Mock Service for Previews
extension UserService {
    static var MOCK_SERVICE: UserService {
        let authVM = AuthViewModel()
        let userService = UserService(authViewModel: authVM)
        userService.currentUser = User.MOCK_USER
        return userService
    }
}
