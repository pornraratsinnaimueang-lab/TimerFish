//
//  LoginView.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                //iamge
                Image("timerFsh-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                //form field
                VStack(spacing: 24) {
                    inputView(text: $email,
                              title:"Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    inputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              inSecureField: true)
                
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //sign in button
                Button {
                    Task {
                        try await viewModel.signIn(withemail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Sign in")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
            
                Spacer()
                
                //sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocal {
    var formIsValid: Bool {
        // Basic validation: non-empty email and password with minimal length
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        password.count >= 6
    }
}

#Preview {
    LoginView()
}
