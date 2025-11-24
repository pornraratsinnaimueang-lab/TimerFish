//
//  TimerFshApp.swift
//  TimerFsh
//
//  Created by Pornrarat Sinnaimueang on 18/11/2568 BE.
//

import SwiftUI
import FirebaseCore // ต้อง Import ตัว Core

// สร้าง Delegate เพื่อเริ่มต้น Firebase ก่อน View
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // คำสั่ง Initialize Firebase
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//
//struct StartView: View {
//    
//    @State var selectedTab = 0
//    
//    var body: some View {
//        
//        TabView(selection: $selectedTab) {
//            Text("Welcome to timer")
//                .font(.largeTitle)
//                .tabItem {
//                    Image(systemName: "timer")
//                    Text("Home")
//                }
//                .tag(0)
//            
//            Text("Welcome to your fish tank")
//                .font(.largeTitle)
//                .tabItem {
//                    Image(systemName: "branding_watermark")
//                    Text("Aquariam")
//                }
//                .tag(1)
//
//            
//            Text("Welcome to the Seashop")
//                .font(.subheadline)
//                .tabItem {
//                    Image(systemName: "shopping_cart")
//                    Text("Shop")
//                }
//                .tag(2)
//
//            
//            Text("Welcome to account management")
//                .font(.subheadline)
//                .tabItem{
//                    Image(systemName: "person.crop.circle")
//                    Text("Account")
//                }
//                .tag(3)
//
//        }
//    }
//}


@main
struct TimerFshApp: App {
    // 1. นำ AppDelegate มาใช้
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

//#Preview {
//    StartView()
//}
