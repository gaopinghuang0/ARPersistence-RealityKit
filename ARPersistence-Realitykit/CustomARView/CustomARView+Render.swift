//
//  CustomARView+Render.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import Foundation
import RealityKit
import ARKit

extension CustomARView {
    
    func addAnchorEntityToScene(anchor: ARAnchor) {
        guard anchor.name == virtualObjectAnchorName else {
            return
        }
        // save the reference to the virtual object anchor when the anchor is added from relocalizing
        if virtualObjectAnchor == nil {
            virtualObjectAnchor = anchor
        }
        
        if let modelEntity = virtualObject.modelEntity {
            print("DEBUG: adding model to scene - \(virtualObject.name)")
            
            // Add modelEntity and anchorEntity into the scene for rendering
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(modelEntity)
            self.scene.addAnchor(anchorEntity)
        } else {
            print("DEBUG: Unable to load modelEntity for \(virtualObject.name)")
        }
    }
    
}
