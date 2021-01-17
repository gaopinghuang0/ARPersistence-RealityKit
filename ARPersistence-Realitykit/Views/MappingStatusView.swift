//
//  MappingStatusView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI

struct MappingStatusView: View {
    var statusLabel: String?
    
    var body: some View {
        Text(statusLabel ?? "Mapping: status")
            .font(.system(size: 15))
            .padding(8)
            .cornerRadius(8)
            .background(Color.gray.opacity(0.4))
    }
}

struct MappingStatusView_Previews: PreviewProvider {
    static var previews: some View {
        MappingStatusView(statusLabel: "Mapping: Limited \nTracking: Initializing")
    }
}
