//
//  Header.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-27.
//

import SwiftUI

struct Header: View {
    @Binding var showGuideView: Bool
    var body: some View {
        HStack (alignment: .center, spacing: 80){
//            Button(action: {
//
//            }) {
//
//                Image(systemName: "arrow.turn.up.left").accentColor(Color.black).font(.system(size: 24, weight: .bold))
//            }
            
            NavigationLink {
                Text("ContentView")
            } label: {
                // existing contents…
                Image(systemName: "arrow.turn.up.left").accentColor(Color.black).font(.system(size: 24, weight: .bold))
            }
            
            // change font or replace w logo
            Text("WATway").frame(maxWidth: .infinity, alignment: .center).accentColor(Color.black).font(.largeTitle) .fontWeight(.bold)
            
            //                        Spacer()
            Button{
                //Action
                self.showGuideView.toggle()
            } label: {
                Image(systemName: "info.circle").font(.system(size: 20, weight: .regular))
            }.accentColor(Color.black)
                .sheet(isPresented: $showGuideView) {
                    GuideView()
                }
        }
    }
}

struct Header_Previews: PreviewProvider {
    @State static var show: Bool = false
    static var previews: some View {
        Header(showGuideView: $show)
    }
}
