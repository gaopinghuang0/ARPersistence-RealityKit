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
        .environmentObject(ARState())
        .environmentObject(SaveLoadData())
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var saveLoadData: SaveLoadData
    @EnvironmentObject var arState: ARState
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        return configuration
    }
    
    func makeUIView(context: Context) -> ARView {
        
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
        let arView = CustomARView(frame: .zero, saveLoadData: saveLoadData, arState: arState)
        
        // Read in any already saved map to see if we can load one.
        if arView.worldMapData != nil {
            saveLoadData.loadButton.isEnabled = true
        }
        
        arView.session.run(defaultConfiguration)
        arView.session.delegate = arView
        
        arView.setupGestures()
        
        arView.debugOptions = [ .showFeaturePoints ]
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
//        uiView.session.
        if saveLoadData.saveButton.isPressed {
            print("DEBUG: saveButton is pressed")
            
            DispatchQueue.main.async {
                self.saveLoadData.saveButton.isPressed = false
            }
        }
    }
 
//    mutating func resetTracking(_ sender: UIButton?) {
//        arView.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
//        isRelocalizingMap = false
//        virtualObjectAnchor = nil
//    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
