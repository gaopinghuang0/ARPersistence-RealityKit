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
    @State private var sessionInfoLabel: String?
    @State private var thumbnailEnabled = false
    @State private var thumbnailImage: UIImage?
    @State private var mappingStatus: String?
    
    var body: some View {
        ZStack {
            ARViewContainer(
                sessionInfoLabel: $sessionInfoLabel,
                thumbnailEnabled: $thumbnailEnabled,
                mappingStatus: $mappingStatus
            )
            .edgesIgnoringSafeArea(.all)

            MainUI(
                sessionInfoLabel: $sessionInfoLabel,
                thumbnailImage: $thumbnailImage,
                mappingStatus: $mappingStatus
            )
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var saveLoadData: SaveLoadData
    
    @Binding var sessionInfoLabel: String?
    @Binding var thumbnailEnabled: Bool
    @Binding var mappingStatus: String?
    
    let arView = ARView(frame: .zero)
    
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
        
        // Read in any already saved map to see if we can load one.
        if worldMapData != nil {
            saveLoadData.loadButton.isEnabled = true
        }
        
        arView.session.run(defaultConfiguration)
        arView.session.delegate = context.coordinator
        
        // Setup gestures
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        arView.addGestureRecognizer(tap)
        
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
    
    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator(self)
    }
    
    // MARK: - Persistence: Saving and Loading
    let storedData = UserDefaults.standard
    
    var worldMapData: Data? {
        storedData.data(forKey: "WorldMap")
    }
    
    // MARK: - AR session management
    
    var isRelocalizingMap = false

    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        return configuration
    }
    
//    mutating func resetTracking(_ sender: UIButton?) {
//        arView.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
//        isRelocalizingMap = false
//        virtualObjectAnchor = nil
//    }
    
    
    // MARK: - Placing AR Content
    
    var virtualObjectAnchor: ARAnchor?
    let virtualObjectAnchorName = "virtualObject"
    var virtualObject = AssetModel(name: "teapot.usdz")
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        // Disable placing objects when the session is still relocalizing
//        if isRelocalizingMap && virtualObjectAnchor == nil {
//            return
//        }
//        // Hit test to find a place for a virtual object.
//        guard let hitTestResult = arView
//                .hitTest(sender.location(in: arView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
//                .first
//        else { return }
//
//        // Remove exisitng anchor and add new anchor
//        if let existingAnchor = virtualObjectAnchor {
//            arView.session.remove(anchor: existingAnchor)
//        }
//        virtualObjectAnchor = ARAnchor(
//            name: virtualObjectAnchorName,
//            transform: hitTestResult.worldTransform
//        )
//        arView.session.add(anchor: virtualObjectAnchor!)
//    }
    

}


class ARViewCoordinator: NSObject, ARSessionDelegate {
    var parent: ARViewContainer

    init(_ control: ARViewContainer) {
        self.parent = control
    }
    
    // MARK: - AR session delegate
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }

    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            parent.saveLoadData.saveButton.isEnabled =
                parent.virtualObjectAnchor != nil && frame.anchors.contains(parent.virtualObjectAnchor!)
        default:
            parent.saveLoadData.saveButton.isEnabled = false
        }
        parent.mappingStatus = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        parent.sessionInfoLabel = "Session was interrupted"
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        parent.sessionInfoLabel = "Session interruption ended"
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        parent.sessionInfoLabel = "Session failed: \(error.localizedDescription)"
        guard error is ARError else { return }

        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]

        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")

        DispatchQueue.main.async {
            print("ERROR: \(errorMessage)")
            print("TODO: show error as an alert.")
        }
    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }

    private func updateSessionInfoLabel(
        for frame: ARFrame,
        trackingState: ARCamera.TrackingState
    ) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String

        parent.thumbnailEnabled = false
        switch (trackingState, frame.worldMappingStatus) {
        case (.normal, .mapped),
             (.normal, .extending):
            if frame.anchors.contains(where: { $0.name == parent.virtualObjectAnchorName }) {
                // User has placed an object in scene and the session is mapped, prompt them to save the experience
                message = "Tap 'Save Experience' to save the current map."
            } else {
                message = "Tap on the screen to place an object."
            }

        case (.normal, _) where parent.worldMapData != nil && !parent.isRelocalizingMap:
            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."

        case (.normal, _) where parent.worldMapData == nil:
            message = "Move around to map the environment."

        case (.limited(.relocalizing), _) where parent.isRelocalizingMap:
            message = "Move your device to the location shown in the image."
            parent.thumbnailEnabled = true
        default:
            message = trackingState.localizedFeedback
        }

        parent.sessionInfoLabel = message
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SaveLoadData())
    }
}
#endif
