//
//  ContentView.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-25.
//


import SwiftUI

// TODO:
// 1, fix guide, text, opening slogans
struct ContentView: View {
        var body: some View {
            NavigationView{
                VStack{
                    MainPage()
                }
            }.toolbar(.hidden, for: .navigationBar)
                
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
