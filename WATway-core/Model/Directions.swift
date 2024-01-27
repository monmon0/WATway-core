//
//  Steps.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Directions: View {
    @Binding var showView: Bool
    
  
    @State private var i = 1
    @State private var maxNum = 5
    
    var body: some View {
        ZStack{
            backgroundVar
            VStack (alignment: .center){
                Header(showGuideView: $showView).padding().frame(minHeight: 100)
                
                ScrollView(showsIndicators: false){
                    
                    HStack{
                        Button{
//                            withAnimation{
//                                i = i - 1
//                            }
                        } label:{
                            Text("See Steps instead")
                        }.buttonStyle(.bordered)
                
                        if(i != 1){
                            Button{
                                withAnimation{
                                    i = i - 1
                                }
                            } label:{
                                Text("See Previous")
                            }.buttonStyle(.borderedProminent)
                        }
                    }
                    
                    
                    Spacer()
                    
                    ForEach(i...maxNum, id: \.self) { val in
                            VStack{
                                Spacer()
                              
                                Image("DC").resizable().frame(maxHeight: 700).scaledToFit().cornerRadius(25).padding()
                                
                                Spacer()
                                
                                Text("Step \(val)").bold().transition(.slide).bold().padding().background(Color.white)
                                    .cornerRadius(25)
                                
                                Text("\(val), Instructions blah blah Instructions blah blah Instructions blah blah Instructions blah blah").font(.title3).padding()
                                
                                Button{
                                    if i < maxNum {
                                        withAnimation{
                                            i = i + 1
                                        }
                                    }
                                    
                                   
                                } label:{
                                    Text("🤗 I'm Here! ").font(.title).bold().padding()
                                }.buttonStyle(.borderedProminent)
                                .accentColor(Color.black).padding()
                                Spacer()
                           
                            }.padding()
                        }
                    
                    Spacer()
                    
         
                        Text("You made it!")
                        AnimatedImage(url: URL(string: "https://media.tenor.com/PCAmJikdf9MAAAAi/goose.gif"))
                            .onFailure { error in
                                // Error
                            }
                            .resizable()
                            .placeholder(UIImage(systemName: "photo")).frame(width: 200, height: 250).scaledToFit().padding()
                    
                    
                    
    
                }
            }.padding()
        }.ignoresSafeArea()
    }
}

struct Directions_Previews: PreviewProvider {
    @State static var showMe: Bool = false
    static var previews: some View {
        Directions(showView: $showMe)
    }
}

