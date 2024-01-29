//
//  Steps.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-25.
//

import SwiftUI
import SDWebImageSwiftUI
import EffectsLibrary

struct Directions: View {
    @Binding var showView: Bool
    
  
    @State private var i = 1
    @State private var maxNum = 5
    @State private var time = 7
    
    var body: some View {
        
        NavigationView{
            ZStack{
                backgroundVar
                VStack (alignment: .center){
                    Header(showGuideView: $showView).padding().frame(minHeight: 100)
                    
                    Spacer()
                    VStack{
                        
                        ProgressView(value: 0.7) {
                            Text("👉  Estimated time: \(time) minutes").font(.title3).bold()
                           
                        }.padding()
                        
                        if (i != maxNum){
                            HStack{
                                Button{
                                    
                                } label: {
                                    Text("Exit Path").font(.title2)
                                }.buttonStyle(.bordered).tint(.pink)
                                
                                
                                Button{
                                    
                                } label:{
                                    Image(systemName: "figure.walk.circle.fill").font(.system(size: 30, weight: .regular)).accentColor(.black)
                                    Text("Steps").font(.title2)
                                    
                                }.buttonStyle(.bordered)

                            }
                        }
                        
                        
                    }.accentColor(Color.black).padding()
                        .background(Color.white).border(.black, width: 4)

                    HStack{
                        
                        Button{
                            if(i > 1 && i <= maxNum){
                                withAnimation{
                                    i = i - 1
                                }
                            }
                        } label:{
                            Image(systemName: "arrowshape.backward").font(.system(size: 30, weight: .regular)).accentColor(.black)
                        }.buttonStyle(.borderedProminent)
                        
                        Button{
                            if(i < maxNum){
                                withAnimation{
                                    i = i + 1
                                }
                            }
                        } label:{
                            Image(systemName: "arrowshape.forward").font(.system(size: 30, weight: .regular)).accentColor(.black)
                        }.buttonStyle(.borderedProminent)
                    }.padding().accentColor(.black)
                    
                    ScrollView(showsIndicators: false){
                        
                        VStack{
                            
                            ForEach(i...maxNum, id: \.self) { val in
                                VStack{
                                    Spacer()
                                    
                                    Image("DC").resizable().frame(maxHeight: 700).scaledToFit().cornerRadius(25)
                                    
                                    Spacer()
                                    
                                    VStack{
                                        Text("Step \(val)").bold().transition(.slide).bold().padding().background(Color.white)
                                            .cornerRadius(25)
                                        
                                        Text("\(val), Instructions blah blah Instructions blah blah Instructions blah blah Instructions blah blah").font(.title3).padding()
                                    }
                                    
                                    
//                                    if i != maxNum {
//                                        Button{
//                                            withAnimation{
//                                                i = i + 1
//                                            }
//                                        } label:{
//                                            Text("🤗 I'm Here! ").font(.title).bold().padding()
//                                        }.buttonStyle(.borderedProminent)
//                                            .accentColor(Color.black).padding()
//                                    }
                                    Spacer()
                                    
                                    
                                }.padding()
                            }
                            
                            Spacer()
                            
                            
                            Text("  🎉 You made it!  🎉").font(.title3).bold().bold().padding().background(Color.white)
                                .cornerRadius(25)
                            AnimatedImage(url: URL(string: "https://media.tenor.com/PCAmJikdf9MAAAAi/goose.gif"))
                                .onFailure { error in
                                    // Error
                                }
                                .resizable()
                                .placeholder(UIImage(systemName: "photo")).frame(width: 200, height: 250).scaledToFit().padding()

                        }
                    }
                }.padding()
             
//                if(i == maxNum){
//                    ConfettiView(
//                               config: ConfettiConfig(
//                                   content: [
//                                    .emoji("🪿", 0.9),
//                                    .emoji("🎉", 0.7),
//                                   ],
//                                   lifetime: .short,
//                                   initialVelocity: .fast
//                               )
//                           )
//                }
            }.ignoresSafeArea()
        }.navigationBarHidden(true)
    }
}


struct Directions_Previews: PreviewProvider {
    @State static var showMe: Bool = false
    static var previews: some View {
        Directions(showView: $showMe)
    }
}

