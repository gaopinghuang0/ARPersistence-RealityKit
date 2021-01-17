//
//  CustomARView+Session.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import Foundation
import RealityKit
import ARKit

extension CustomARView: ARSessionDelegate {
    
    // MARK: - AR session delegate
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // This is where we render virtual contents to scene.
    // We add an anchor in `handleTap` function, it will then call this function.
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("did add anchor: \(anchors.count) anchors in total")
        
        for anchor in anchors {
            addAnchorEntityToScene(anchor: anchor)
        }
    }
    
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            saveLoadData?.saveButton.isEnabled =
                virtualObjectAnchor != nil && frame.anchors.contains(virtualObjectAnchor!)
        default:
            saveLoadData?.saveButton.isEnabled = false
        }
        arState?.mappingStatus = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        arState?.sessionInfoLabel = "Session was interrupted"
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        arState?.sessionInfoLabel = "Session interruption ended"
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        arState?.sessionInfoLabel = "Session failed: \(error.localizedDescription)"
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

        arState?.thumbnailEnabled = false
        switch (trackingState, frame.worldMappingStatus) {
        case (.normal, .mapped),
             (.normal, .extending):
            if frame.anchors.contains(where: { $0.name == self.virtualObjectAnchorName }) {
                // User has placed an object in scene and the session is mapped, prompt them to save the experience
                message = "Tap 'Save Experience' to save the current map."
            } else {
                message = "Tap on the screen to place an object."
            }

        case (.normal, _) where self.worldMapData != nil && !self.isRelocalizingMap:
            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."

        case (.normal, _) where self.worldMapData == nil:
            message = "Move around to map the environment."

        case (.limited(.relocalizing), _) where self.isRelocalizingMap:
            message = "Move your device to the location shown in the image."
            arState?.thumbnailEnabled = true
        default:
            message = trackingState.localizedFeedback
        }

        arState?.sessionInfoLabel = message
    }
    
}
