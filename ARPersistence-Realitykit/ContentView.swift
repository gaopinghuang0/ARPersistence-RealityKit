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
    @State private var showingAlert = false
    @State private var alertMessage: String?
    // Save and load
//    @State private var saver = false
//    @State private var loader = false
//    @State private var isLoadButtonEnabled = false
//    @State private var isSaveButtonEnabled = false
    
    var body: some View {
        ZStack {
            ARViewContainer(
                sessionInfoLabel: $sessionInfoLabel,
                thumbnailEnabled: $thumbnailEnabled,
                showingAlert: $showingAlert,
                alertMessage: $alertMessage
            ).edgesIgnoringSafeArea(.all)
            
            MainUI(
                sessionInfoLabel: $sessionInfoLabel,
                thumbnailImage: $thumbnailImage,
                mappingStatus: $mappingStatus
            )
        }
//        .alert(isPresented: self.$showingAlert) {
//            Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
//        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var saveLoadData: SaveLoadData
    
    @Binding var sessionInfoLabel: String?
    @Binding var thumbnailEnabled: Bool
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String?
    
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
//        if worldMapData != nil {
//            saveLoadData.loadButton.isEnabled = true
//        }
        
        arView.session.run(defaultConfiguration)
//        arView.session.delegate = context.coordinator
        
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
    
    // MARK: - AR session delegate
//    func makeCoordinator() -> ARViewCoordinator{
//        ARViewCoordinator(self)
//    }
    
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
//
//    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//
//        guard let touchInView = sender?.location(in: arView) else {
//            return
//        }
//
//        rayCastingMethod(point: touchInView)
//
//        //to find whether an entity exists at the point of contact
//        let entities = self.entities(at: touchInView)
//    }
//
//    func rayCastingMethod(point: CGPoint) {
//
//
//        guard let coordinator = self.session.delegate as? ARViewCoordinator else{ print("GOOD NIGHT"); return }
//
//        guard let raycastQuery = self.makeRaycastQuery(from: point,
//                                                       allowing: .existingPlaneInfinite,
//                                                       alignment: .horizontal) else {
//
//                                                        print("failed first")
//                                                        return
//        }
//
//        guard let result = self.session.raycast(raycastQuery).first else {
//            print("failed")
//            return
//        }
//
//        let transformation = Transform(matrix: result.worldTransform)
//        let box = CustomBox(color: .yellow)
//        self.installGestures(.all, for: box)
//        box.generateCollisionShapes(recursive: true)
//
//        let mesh = MeshResource.generateText(
//            "\(coordinator.overlayText)",
//            extrusionDepth: 0.1,
//            font: .systemFont(ofSize: 2),
//            containerFrame: .zero,
//            alignment: .left,
//            lineBreakMode: .byTruncatingTail)
//
//        let material = SimpleMaterial(color: .red, isMetallic: false)
//        let entity = ModelEntity(mesh: mesh, materials: [material])
//        entity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
//
//        box.addChild(entity)
//        box.transform = transformation
//
//        entity.setPosition(SIMD3<Float>(0, 0.05, 0), relativeTo: box)
//
//        let raycastAnchor = AnchorEntity(raycastResult: result)
//        raycastAnchor.addChild(box)
//        self.scene.addAnchor(raycastAnchor)
//    }
    
    /// - Tag: PlaceObject
//    mutating func handleSceneTap(_ sender: UITapGestureRecognizer) {
//        // Disable placing objects when the session is still relocalizing
//        if isRelocalizingMap && virtualObjectAnchor == nil {
//            return
//        }
//        // Hit test to find a place for a virtual object.
//        guard let hitTestResult = arView
//            .hitTest(sender.location(in: arView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
//            .first
//            else { return }
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

//    var virtualObjectAnchor: ARAnchor?
//    let virtualObjectAnchorName = "virtualObject"
//
//    var virtualObject: SCNNode = {
//        guard let sceneURL = Bundle.main.url(forResource: "cup", withExtension: "scn", subdirectory: "Assets.scnassets/cup"),
//            let referenceNode = SCNReferenceNode(url: sceneURL) else {
//                fatalError("can't load virtual object")
//        }
//        referenceNode.load()
//
//        return referenceNode
//    }()
//
}
//
//
//class ARViewCoordinator: NSObject, ARSessionDelegate {
//    var arVC: ARViewContainer
//
//    init(_ control: ARViewContainer) {
//        self.arVC = control
//    }
//
//    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
//    }
//
//    /// - Tag: CheckMappingStatus
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
//        arVC.sessionInfoLabel = "Session was interrupted"
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required.
//        arVC.sessionInfoLabel = "Session interruption ended"
//    }
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        arVC.sessionInfoLabel = "Session failed: \(error.localizedDescription)"
//        guard error is ARError else { return }
//
//        let errorWithInfo = error as NSError
//        let messages = [
//            errorWithInfo.localizedDescription,
//            errorWithInfo.localizedFailureReason,
//            errorWithInfo.localizedRecoverySuggestion
//        ]
//
//        // Remove optional error messages.
//        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
//
//        DispatchQueue.main.async {
//            self.arVC.showingAlert = true
//            self.arVC.alertMessage = errorMessage
//        }
//    }
//
//    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
//        return true
//    }
//
//    func updateSessionInfoLabel(
//        for frame: ARFrame,
//        trackingState: ARCamera.TrackingState
//    ) {
//        // Update the UI to provide feedback on the state of the AR experience.
//        let message: String
//
//        arVC.thumbnailEnabled = false
//        switch (trackingState, frame.worldMappingStatus) {
//        case (.normal, .mapped),
//             (.normal, .extending):
//            if frame.anchors.contains(where: { $0.name == arVC.virtualObjectAnchorName }) {
//                // User has placed an object in scene and the session is mapped, prompt them to save the experience
//                message = "Tap 'Save Experience' to save the current map."
//            } else {
//                message = "Tap on the screen to place an object."
//            }
//
//        case (.normal, _) where arVC.worldMapData != nil && !arVC.isRelocalizingMap:
//            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."
//
//        case (.normal, _) where arVC.worldMapData == nil:
//            message = "Move around to map the environment."
//
//        case (.limited(.relocalizing), _) where arVC.isRelocalizingMap:
//            message = "Move your device to the location shown in the image."
//            arVC.thumbnailEnabled = true
//        default:
//            message = trackingState.localizedFeedback
//        }
//
//        arVC.sessionInfoLabel = message
//    }
//}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SaveLoadData())
    }
}
#endif
