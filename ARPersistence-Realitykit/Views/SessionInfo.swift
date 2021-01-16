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
        Text(label ?? "")
            .padding(10)
            .background(Color.gray.opacity(0.3))
    }
}

struct SessionInfo_Previews: PreviewProvider {
    static var previews: some View {
        SessionInfo(label: "Initializing AR session.")
    }
}
