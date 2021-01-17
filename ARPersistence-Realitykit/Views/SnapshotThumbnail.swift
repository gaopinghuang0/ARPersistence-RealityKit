//
//  SnapshotView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//
import UIKit
import SwiftUI

struct SnapshotThumbnail: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(12)
    }
}

struct SnapshotThumbnail_Previews: PreviewProvider {
    static var image = UIImage(named: "AppIcon")!
    static var previews: some View {
        SnapshotThumbnail(image: image)
    }
}
