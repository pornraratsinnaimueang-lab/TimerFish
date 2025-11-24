import SwiftUI

struct ContentView: View {
    
    // ดึง ViewModel มาจาก Environment
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfileView()
            }else {
                LoginView()
            }
        }
    }
}
