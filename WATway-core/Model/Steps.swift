//
//  Steps.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-31.
//

import SwiftUI

struct Steps: View {
    @Binding var showView: Bool
    @State private var i = 1
    @State private var maxNum = 5
    @State private var time = 7
    
    @State private var exitPath: Bool = false
    @State private var openDirections: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundVar
                VStack{
                    Header(showGuideView: $showView).padding().frame(minHeight: 100)
                    
                    ScrollView(showsIndicators: false){
                        
                        VStack{
                            ForEach(i...maxNum, id: \.self) { val in
                                VStack{
                                    HStack{
                                        Image(systemName: "arrow.turn.up.left").padding()
                                        Text("Go to DC").bold().transition(.slide).bold().padding().background(Color.white)
                                        Spacer()
                                        Image("DC").resizable().scaledToFit().padding()
                                    }.frame(maxWidth: .infinity, maxHeight: 80).background(Color.white).cornerRadius(10)
                                    Divider().accentColor(.white)
                                }
                            }
                            HStack{
                                
                                NavigationLink("",destination: ContentView(), isActive: $exitPath).navigationBarHidden(true).navigationBarTitle("")
                                
                                
                                Button{
                                    self.exitPath.toggle()
                                } label: {
                                    Image(systemName: "x.circle.fill").font(.system(size: 30, weight: .regular)).accentColor(.black)
                                   
                                    Text("Exit Path").font(.title2)
                                }.buttonStyle(.borderedProminent).accentColor(.pink)
                                
                                NavigationLink("",destination: Directions(showView: $showView), isActive: $openDirections).navigationBarHidden(true).navigationBarTitle("")
                                
                                Button{
                                    withAnimation{
                                        openDirections = true
                                    }
                                } label:{
                                    Image(systemName: "location.circle.fill").font(.system(size: 30, weight: .regular)).accentColor(.black)
                                    Text("Directions").font(.title2)
                                    
                                }.buttonStyle(.borderedProminent)
                            }.padding()
                        }
                    }
                    Spacer()
                }.padding()
            }.ignoresSafeArea()
        }.navigationBarHidden(true)
    }
}

struct Steps_Previews: PreviewProvider {
    @State static var showMe: Bool = false
    static var previews: some View {
        Steps(showView: $showMe)
    }
}
