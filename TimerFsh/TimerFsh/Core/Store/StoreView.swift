//
//  StoreView.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import SwiftUI

// These models would typically be in their own files
struct StoreItem: Identifiable {
    enum ItemType { case fish, furniture }
    let id = UUID()
    let itemId: String
    let name: String
    let type: ItemType
    let price: Int
}

// Mock data for the store
let fishMasterList: [StoreItem] = [
    StoreItem(itemId: "fish_clownfish", name: "Clownfish", type: .fish, price: 100),
    StoreItem(itemId: "fish_tang", name: "Blue Tang", type: .fish, price: 150),
    StoreItem(itemId: "fish_puffer", name: "Pufferfish", type: .fish, price: 200),
]

let furnitureMasterList: [StoreItem] = [
    StoreItem(itemId: "furn_castle", name: "Small Castle", type: .furniture, price: 500),
    StoreItem(itemId: "furn_chest", name: "Treasure Chest", type: .furniture, price: 350),
    StoreItem(itemId: "furn_plant", name: "Seaweed Plant", type: .furniture, price: 50),
]


struct StoreView: View {
    @EnvironmentObject var userService: UserService
    let allItems = fishMasterList + furnitureMasterList
    
    @State private var error: Error?
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            VStack {
                // User Coins Display
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("\(userService.currentUser?.coins ?? 0)")
                    Spacer()
                }
                .font(.title2)
                .padding()

                List(allItems) { item in
                    HStack {
                        Image(systemName: item.type == .fish ? "fish.fill" : "house.fill")
                            .font(.title)
                            .frame(width: 40)
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text("Price: \(item.price) coins").foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: { purchase(item) }) {
                            Text("Buy")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Store")
            .alert(isPresented: $showingError) {
                Alert(title: Text("Purchase Failed"), message: Text(error?.localizedDescription ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func purchase(_ item: StoreItem) {
        Task {
            do {
                try await DatabaseService.shared.purchaseItem(item: item)
                print("Purchase button tapped for \(item.name). Functionality pending.")
            } catch {
                self.error = error
                showingError.toggle()
            }
        }
    }
}
