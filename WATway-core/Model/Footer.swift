//
//  footer.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-21.
//

import SwiftUI

struct Footer: View {
    
    @Binding var location: String
    @Binding var time: String
    
    @State private var openDirections: Bool = false
    @State private var openSteps: Bool = false
    @State private var showView: Bool = false
    

    var body: some View {
        VStack (){
//            Capsule()
//                .frame(width: 120, height: 6)
//                .foregroundColor(Color.secondary)
//                .opacity(0.2).padding(.bottom, 10)
            HStack(spacing: 5){
                
                Text(location)
                Text(time + " mins").bold()
            }
            HStack {
                Spacer()
            
                NavigationLink("",destination: Directions(showView: $showView), isActive: $openDirections).navigationBarHidden(true).navigationBarTitle("")
                
                Button () {
                    withAnimation{
                        openDirections = true
                    }
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill").font(.system(size: 34, weight: .regular))
                    Text("Directions")
                    
                    
                }.buttonStyle(.bordered)
                
                Spacer()
                
                NavigationLink("",destination: Steps(showView: $showView), isActive: $openSteps).navigationBarHidden(true).navigationBarTitle("")
                
                Button () {
                    withAnimation{
                        openSteps = true
                    }
                } label: {
                    Image(systemName: "figure.walk.circle.fill").font(.system(size: 34, weight: .regular))
                    Text("Steps")
                }.buttonStyle(.bordered)
                
                
                Button () {
                    
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle.fill").font(.system(size: 34, weight: .regular))
                }.padding()
           
            }
            Button{
            } label: {Text("See the whole layout")}
        }
 
    }
}

struct footer_Previews: PreviewProvider {
    @State static var location = "DC"
    @State static var time = "7"
    static var previews: some View {
        Footer(location: $location, time: $time).previewLayout(.fixed(width: 375, height: 80))
    }
}
