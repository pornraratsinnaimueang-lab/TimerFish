//
//  inputView.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 19/11/2568 BE.
//

import SwiftUI

struct inputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var inSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if inSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size:14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size:14))
            }
            Divider()
        }
    }
}

struct inputView_Preview: PreviewProvider {
    static var previews: some View {
        inputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
