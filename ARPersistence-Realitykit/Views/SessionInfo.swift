//
//  SessionInfo.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI

struct SessionInfo: View {
    var label: String?
    
    var body: some View {
        if let text = label {
            Text(text)
                .font(.system(size: 15))
                .padding(8)
                .cornerRadius(8)
                .background(Color.gray.opacity(0.4))
        }
    }
}

struct SessionInfo_Previews: PreviewProvider {
    static var previews: some View {
        SessionInfo(label: "Initializing AR session.")
    }
}
