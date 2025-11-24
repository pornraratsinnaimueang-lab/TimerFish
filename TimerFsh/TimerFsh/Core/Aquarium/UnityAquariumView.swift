//
//  UnityAquariumView.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import SwiftUI
import UIKit

// This protocol defines a communication channel from the UIKit view back to SwiftUI.
protocol UnityAquariumDelegate {
    func didUpdateLayout(_ layout: [[String: Any]])
}

// This is a mock UIViewController that simulates a Unity view.
class UnityAquariumViewController: UIViewController {
    var delegate: UnityAquariumDelegate?
    var initialLayout: [[String: Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan.withAlphaComponent(0.2)
        
        let label = UILabel()
        label.text = "Mock Unity Aquarium View"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
        
        // Simulate loading the initial layout passed from SwiftUI.
        if let layout = initialLayout {
            print("Unity view received initial layout: \(layout)")
        }

        // Button to simulate Unity sending an updated layout back to Swift.
        let button = UIButton(type: .system, primaryAction: UIAction(title: "Simulate Layout Update from Unity") { _ in
            let updatedLayout: [[String: Any]] = [
                ["itemId": "fish_clownfish", "x": 100, "y": 150],
                ["itemId": "furn_castle", "x": 200, "y": 250]
            ]
            print("Unity view is sending updated layout back to SwiftUI.")
            self.delegate?.didUpdateLayout(updatedLayout)
        })
        button.frame = CGRect(x: 20, y: view.bounds.height - 100, width: view.bounds.width - 40, height: 50)
        view.addSubview(button)
    }
}

// This struct wraps the UIViewController so it can be used in a SwiftUI view hierarchy.
struct UnityAquariumView: UIViewControllerRepresentable {
    @Binding var layout: [[String: Any]]
    let delegate: UnityAquariumDelegate

    func makeUIViewController(context: Context) -> UnityAquariumViewController {
        let vc = UnityAquariumViewController()
        vc.delegate = delegate
        vc.initialLayout = layout
        return vc
    }

    func updateUIViewController(_ uiViewController: UnityAquariumViewController, context: Context) {
        // This can be used to pass data from SwiftUI to the UIKit view controller
    }
}

// A container view to manage the state and logic for the mocked Unity integration.
struct UnityAquariumContainerView: View, UnityAquariumDelegate {
    @EnvironmentObject var userService: UserService
    @State private var aquariumLayout: [[String: Any]] = []
    
    var body: some View {
        VStack {
            UnityAquariumView(layout: $aquariumLayout, delegate: self)
                .edgesIgnoringSafeArea(.all)
            
            // Display inventory for context
            HStack(alignment: .top) {
                VStack {
                    Text("Fish").font(.headline)
                    ForEach(userService.currentUser?.fishInventory ?? [], id: \.self) { fishId in
                        Text(fishId.replacingOccurrences(of: "fish_", with: "").capitalized)
                    }
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text("Furniture").font(.headline)
                    ForEach(userService.currentUser?.furnitureInventory ?? [], id: \.self) { furnId in
                        Text(furnId.replacingOccurrences(of: "furn_", with: "").capitalized)
                    }
                }
                .padding()
            }
            .frame(height: 150)
        }
        .onAppear(perform: loadInitialLayout)
    }
    
    private func loadInitialLayout() {
        self.aquariumLayout = userService.currentUser?.aquariumLayout ?? []
    }
    
    // This is the delegate method called by the mock Unity view.
    func didUpdateLayout(_ layout: [[String : Any]]) {
        print("SwiftUI container received layout update from delegate.")
        self.aquariumLayout = layout
        Task {
            do {
                try await userService.updateAquariumLayout(layout: layout)
            } catch {
                print("Error saving updated layout: \(error.localizedDescription)")
            }
        }
    }
}
