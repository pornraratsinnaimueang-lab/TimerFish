import Foundation

// NOTE: This model has been modified to remove the dependency on FirebaseFirestoreSwift.
struct User: Identifiable {
    let id: String // This is the UID from Firebase Auth
    let username: String
    let email: String
    var coins: Int
    var fishInventory: [String]
    var furnitureInventory: [String]
    var aquariumLayout: [[String: Any]]

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: username) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }

    // Manual initializer from a Firestore dictionary
    init?(id: String, data: [String: Any]) {
        self.id = id
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.coins = data["coins"] as? Int ?? 0
        self.fishInventory = data["fishInventory"] as? [String] ?? []
        self.furnitureInventory = data["furnitureInventory"] as? [String] ?? []
        self.aquariumLayout = data["aquariumLayout"] as? [[String: Any]] ?? []
    }
    
    // Initializer for creating a new user with default values
    init(id: String, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
        self.coins = 500 // Default value
        self.fishInventory = []
        self.furnitureInventory = []
        self.aquariumLayout = []
    }
    
    // Full initializer for creating mock data or other specific instances
    init(id: String, username: String, email: String, coins: Int, fishInventory: [String], furnitureInventory: [String], aquariumLayout: [[String: Any]]) {
        self.id = id
        self.username = username
        self.email = email
        self.coins = coins
        self.fishInventory = fishInventory
        self.furnitureInventory = furnitureInventory
        self.aquariumLayout = aquariumLayout
    }

    // Convert the object to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "uid": id,
            "username": username,
            "email": email,
            "coins": coins,
            "fishInventory": fishInventory,
            "furnitureInventory": furnitureInventory,
            "aquariumLayout": aquariumLayout
        ]
    }
}

extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        username: "Nikita Sin",
        email: "nikitasin@gmail.com",
        coins: 1250,
        fishInventory: ["fish_clownfish", "fish_tang"],
        furnitureInventory: ["furn_castle"],
        aquariumLayout: []
    )
}
