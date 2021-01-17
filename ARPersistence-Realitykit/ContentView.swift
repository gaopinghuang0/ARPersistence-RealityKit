//
//  ContentView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)

            MainUI()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var saveLoadState: SaveLoadState
    @EnvironmentObject var arState: ARState
    
    func makeUIView(context: Context) -> CustomARView {
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Pass in @EnvironmentObject
        let arView = CustomARView(frame: .zero, saveLoadState: saveLoadState, arState: arState)
        
        // Read in any already saved map to see if we can load one.
        if arView.worldMapData != nil {
            saveLoadState.loadButton.isHidden = false
        }
        
        arView.setup()

        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        
        if saveLoadState.saveButton.isPressed {
            uiView.saveExperience()
            
            DispatchQueue.main.async {
                self.saveLoadState.saveButton.isPressed = false
            }
        }
        
        if saveLoadState.loadButton.isPressed {
            uiView.loadExperience()
            self.saveLoadState.loadButton.isPressed = false
            // Note: If we reset isPressed to false in main.async, it will crash
            // DispatchQueue.main.async {
            //      self.saveLoadData.loadButton.isPressed = false
            // }
        }
        
        if arState.resetButton.isPressed {
            uiView.resetTracking()
            
            DispatchQueue.main.async {
                self.arState.resetButton.isPressed = false
            }
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
