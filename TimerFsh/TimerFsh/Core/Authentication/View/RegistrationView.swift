//
//  RegistrationView.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
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
                
                inputView(text: $username,
                          title:"Username",
                          placeholder: "Enter your username")
                .autocapitalization(.none)
                
                inputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          inSecureField: true)
                
                ZStack(alignment: .trailing) {
                    inputView(text: $confirmPassword,
                              title: "Confirm your password",
                              placeholder: "Confirm your password",
                              inSecureField: true)
                    
                    if !password.isEmpty && password != confirmPassword {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGreen))
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, username: username)
                }
            } label: {
                HStack {
                    Text("Sign up")
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
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocal {
    var formIsValid: Bool {
        // Basic validation: non-empty email and password with minimal length
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        !username.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
