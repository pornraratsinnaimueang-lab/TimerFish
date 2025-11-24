//
//  ProfileView.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userService: UserService
    
    // We still need AuthViewModel for signing out
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if let user = userService.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.username)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)

                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Stats") {
                    HStack {
                        Text("Coins")
                        Spacer()
                        Text("\(user.coins)")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Fish Count")
                        Spacer()
                        Text("\(user.fishInventory.count)")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Furniture Count")
                        Spacer()
                        Text("\(user.furnitureInventory.count)")
                            .foregroundColor(.gray)
                    }
                }

                Section("General") {
                    HStack {
                        SettingRowView(imageName: ("gear"), title: "Version", tintColor: Color(.systemGray))

                        Spacer()

                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Section("Account") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingRowView(imageName: ("arrow.left.circle.fill"), title: "Sign out", tintColor: Color(.red))
                    }

                    Button {
                        print("Delete account..")
                    } label: {
                        SettingRowView(imageName: ("xmark.circle.fill"), title: "Delete Account", tintColor: Color(.red))
                    }
                }
            }
        } else {
            // Fallback while loading currentUser
            ProgressView("Loading profile…")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserService.MOCK_SERVICE)
        .environmentObject(AuthViewModel()) // Still needs a dummy auth view model
}
