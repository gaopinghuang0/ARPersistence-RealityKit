//
//  SaveLoadData.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/16/21.
//

import Foundation

final class SaveLoadState: ObservableObject {
    @Published var saveButton = ButtonState(isEnabled: false)
    @Published var loadButton = ButtonState(isHidden: true)
}
