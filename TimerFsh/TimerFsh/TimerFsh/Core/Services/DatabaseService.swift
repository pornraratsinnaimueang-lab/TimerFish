//
//  DatabaseService.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class DatabaseService {
    static let shared = DatabaseService()
    private let db = Firestore.firestore()

    private init() {}
    
    enum AppError: Error, LocalizedError {
        case insufficientFunds
        case firestoreError(String)

        var errorDescription: String? {
            switch self {
            case .insufficientFunds:
                return "You do not have enough coins."
            case .firestoreError(let string):
                return string
            }
        }
    }

    /// Atomically purchases an item, checking for funds, deducting cost, and adding to inventory using a Transaction.
        func purchaseItem(item: StoreItem) async throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw AppError.firestoreError("User not authenticated.")
            }
    
            let userDocRef = db.collection("users").document(uid)
            
            try await db.runTransaction { (transaction, errorPointer) -> Any? in
                let userDocument: DocumentSnapshot
                do {
                    try userDocument = transaction.getDocument(userDocRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
    
                guard let currentCoins = userDocument.data()?["coins"] as? Int else {
                    let error = AppError.firestoreError("Could not read user's coin balance.")
                    errorPointer?.pointee = error as NSError
                    return nil
                }
                
                if currentCoins < item.price {
                    let error = AppError.insufficientFunds
                    errorPointer?.pointee = error as NSError
                    return nil
                }
                
                transaction.updateData(["coins": currentCoins - item.price], forDocument: userDocRef)
                
                let inventoryField = item.type == .fish ? "fishInventory" : "furnitureInventory"
                transaction.updateData([inventoryField: FieldValue.arrayUnion([item.itemId])], forDocument: userDocRef)
                
                return nil
            }
            print("Transaction successful: \(item.name) purchased.")
        }
    /// Atomically records a lap, updates user coins, and adds a reward item using a Batch Write.
    func recordLapAndUpdateUser(duration: Int, earnedCoins: Int, rewardItem: String?, folderId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.firestoreError("User not authenticated.")
        }

        let userDocRef = db.collection("users").document(uid)
        let newLapRef = db.collection("folders").document(folderId).collection("laps").document()
        
        let newLapRecord = LapRecord(
            timestamp: Date(),
            duration: duration,
            earnedCoins: earnedCoins,
            earnedReward: rewardItem ?? "None"
        )
        
        let batch = db.batch()
        
        // Manually create dictionary for the lap record
        let lapData: [String: Any] = [
            "timestamp": newLapRecord.timestamp,
            "duration": newLapRecord.duration,
            "earnedCoins": newLapRecord.earnedCoins,
            "earnedReward": newLapRecord.earnedReward
        ]
        batch.setData(lapData, forDocument: newLapRef)
        
        batch.updateData(["coins": FieldValue.increment(Int64(earnedCoins))], forDocument: userDocRef)
        
        if let item = rewardItem, item.hasPrefix("fish_") {
            batch.updateData(["fishInventory": FieldValue.arrayUnion([item])], forDocument: userDocRef)
        } else if let item = rewardItem, item.hasPrefix("furn_") {
            batch.updateData(["furnitureInventory": FieldValue.arrayUnion([item])], forDocument: userDocRef)
        }
        
        try await batch.commit()
        print("Batch write successful: Lap recorded and user profile updated.")
    }
}


struct LapRecord: Identifiable, Hashable {
    var id: String = UUID().uuidString
    let timestamp: Date
    let duration: Int // seconds
    let earnedCoins: Int
    let earnedReward: String
}

