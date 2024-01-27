//
//  GuideComponents.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-22.
//

import SwiftUI
import Foundation

struct GuideComponents: View {
    var title: String
    var subtitle: String
    var description: String
    var icon: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(Color.pink)
            
            VStack(alignment: .leading, spacing: 4){
                HStack {
                    Text(title.uppercased())
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    
                    Text(subtitle.uppercased())
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.pink)
                }
                Divider().padding(.bottom, 4)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        }
}

struct GuideComponents_Previews: PreviewProvider {
    static var previews: some View {
        GuideComponents(title: "Title", subtitle: "Swipe Right", description: "This is a placeholder mf. Please just let the product live", icon: "heart.circle" )
            .previewLayout(.sizeThatFits)
    }
}
