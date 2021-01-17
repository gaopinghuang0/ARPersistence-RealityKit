//
//  ARState.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import Foundation
import SwiftUI

final class ARState: ObservableObject {
    @Published var sessionInfoLabel = "Initializing"
    @Published var thumbnailEnabled = false
    @Published var thumbnailImage: UIImage?
    @Published var mappingStatus = "Mapping: "
}
