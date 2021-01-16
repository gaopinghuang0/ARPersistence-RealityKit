//
//  MainUI.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI

struct MainUI: View {
    
    @Binding var sessionInfoLabel: String?
    @Binding var thumbnailImage: UIImage?
    @Binding var mappingStatus: String?
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    if let image = thumbnailImage {
                        SnapshotThumbnail(image: image)
                            .frame(width: 100, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }
                
                HStack {
                    MappingStatusView(statusLabel: mappingStatus)
                        .frame(maxWidth: 100, alignment: .center)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing, 20)
                }
            }
            
            Spacer()
            
            SessionInfo(label: sessionInfoLabel)
            SaveLoadButton()
        }
    }
}

struct MainUI_Previews: PreviewProvider {
    static var image = UIImage(named: "AppIcon")!
    static var previews: some View {
        MainUI(sessionInfoLabel: .constant("Initializing"), thumbnailImage: .constant(image), mappingStatus: .constant("Mapping: Limited \nTracking: Initializing"))
            .environmentObject(SaveLoadData())
    }
}
