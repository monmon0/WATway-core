//
//  HeaderComponents.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-22.
//

import SwiftUI
import Foundation

struct HeaderComponents: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Capsule()
                .frame(width: 120, height: 6)
                .foregroundColor(Color.secondary)
                .opacity(0.2)
            Text("WATway").frame(maxWidth: .infinity, alignment: .center).accentColor(Color.black).font(.largeTitle) .fontWeight(.bold)
            
            
            
        }
        
    }
}

struct HeaderComponents_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponents()
    }
}
