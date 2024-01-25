//
//  HomeView.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-22.
//

import SwiftUI

struct HomeView: View {
    
//    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button{
//                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Spacer()
            Text("Home View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var showMenu: Bool = false
    static var previews: some View {
        HomeView()
    }
}
