import SwiftUI

struct ContentView: View {
    
    // ดึง ViewModel มาจาก Environment
        @EnvironmentObject var authViewModel: AuthViewModel
        var body: some View {
            Group {
                if authViewModel.userSession != nil {
                    MainTabView()
                }else {
                    LoginView()
                }
        }
    }
}
