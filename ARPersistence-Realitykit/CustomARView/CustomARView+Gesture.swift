//
//  CustomARView+Gesture.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import SwiftUI


//extension CustomARView {
//
//    /// Add the tap gesture recogniser
//    func setupGestures() {
//      let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//      self.addGestureRecognizer(tap)
//    }
//
//    // MARK: - Placing AR Content
//
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
//
//}
