//
//  RoundedButton.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI

struct SaveLoadButton: View {
    @EnvironmentObject var saveLoadState: SaveLoadState

    var body: some View {
        HStack {
            // Load Button
            if !saveLoadState.loadButton.isHidden {
                Button(action: {
                    print("DEBUG: Load ARWorld map.")
                    
                    saveLoadState.loadButton.isPressed = true
                }) {
                    Text("Load Experience")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                }
                .background(Color.blue)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!saveLoadState.loadButton.isEnabled)
            }
            
            // Save Button
            Button(action: {
                print("DEBUG: Save ARWorld map.")
                
                saveLoadState.saveButton.isPressed = true
            }) {
                Text("Save Experience")
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                
            }
            .background(saveLoadState.saveButton.isEnabled ? Color.blue : Color.gray)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!saveLoadState.saveButton.isEnabled)
        }
    }
}

struct SaveLoadButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveLoadButton()
            .environmentObject(SaveLoadState())
    }
}
