//
//  CustomARView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//
import SwiftUI
import RealityKit
import ARKit

class CustomARView: ARView {
    // Referring to @EnvironmentObject
    var saveLoadData: SaveLoadData?
    var arState: ARState?
    
    init(frame frameRect: CGRect, saveLoadData: SaveLoadData, arState: ARState) {
        super.init(frame: frameRect)
        self.saveLoadData = saveLoadData
        self.arState = arState
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    // MARK: - AR content
    var virtualObjectAnchor: ARAnchor?
    let virtualObjectAnchorName = "virtualObject"
    var virtualObject = AssetModel(name: "teapot.usdz")
    
    
    // MARK: - AR session management
    var isRelocalizingMap = false
    
 
    // MARK: - Persistence: Saving and Loading
    let storedData = UserDefaults.standard

    var worldMapData: Data? {
        storedData.data(forKey: "WorldMap")
    }

}
