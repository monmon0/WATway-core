//
//  ContentView.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-25.
//

import SwiftUI

struct ContentView: View {
 
        @State var showGuide: Bool = false
        @State var showMenu: Bool = false
      
        
        var body: some View {
                VStack{

                    MainPage()
                    
                    //Footer
                    Divider()
                    // hide wen the input its not put in yet
                    Footer()
                }
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
