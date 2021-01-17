//
//  SaveLoadData.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/16/21.
//

import Foundation

final class SaveLoadData: ObservableObject {
    @Published var saveButton = ButtonInfo(isEnabled: false)
    @Published var loadButton = ButtonInfo(isHidden: true)
}
