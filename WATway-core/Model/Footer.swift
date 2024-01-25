//
//  footer.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-21.
//

import SwiftUI

struct Footer: View {
    var body: some View {
        VStack (){
            Capsule()
                .frame(width: 120, height: 6)
                .foregroundColor(Color.secondary)
                .opacity(0.2).padding(.bottom, 10)
            HStack(spacing: 5){
                
                Text("DC (Ring Road / Near E7)")
                Text("7 mins").bold()
            }
            HStack {
                Spacer()
            
                Button () {
                    
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill").font(.system(size: 34, weight: .regular))
                    Text("Directions")
                }.buttonStyle(.bordered)
                
                Spacer()
                Button () {
                    
                } label: {
                    Image(systemName: "figure.walk.circle.fill").font(.system(size: 34, weight: .regular))
                    Text("Steps")
                }.buttonStyle(.bordered)
                
                Button () {
                    
                } label: {
                    Image(systemName: "house.fill").font(.system(size: 34, weight: .regular))
                }.padding()
           
            }
            Button{
            } label: {Text("See the whole layout")}
        }.padding()
 
    }
}

struct footer_Previews: PreviewProvider {
    static var previews: some View {
        Footer().previewLayout(.fixed(width: 375, height: 80))
    }
}
