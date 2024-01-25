//
//  ContentView.swift
//  SwiftUIBurgerMenu
//
//  Created by Florent Morin on 02/06/2021.
//

import SwiftUI
import Foundation
import Kingfisher

extension Notification.Name {
    static let displayBurgerMenu = Self.init("DisplayBurgerMenuNotification")
    static let hideBurgerMenu = Self.init("HideBurgerMenuNotification")
}

struct HamburgMenu: View {
    var title: String = "Navigation"
    
    // make  a list of selections seperately
    @State private var selection = "Where are you going?"
       let colors = ["Where are you at?", "DC or somewhere", "Green", "Blue", "Black", "Tartan"]
    
    @State private var destination = "Where are you going?"
       let des = ["Where are you heading?", "DC or somewhere", "Green", "Blue", "Black", "Tartan"]
    
    @Binding var showGuideView: Bool
    
    var body: some View {
        NavigationView {
            // pretty useful maybe can make it into instructions later
            VStack{
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "mappin.and.ellipse").font(.system(size: 20, weight: .regular)).accentColor(Color.blue)
                       
                        Picker("Where are you going?", selection: $selection) {
                                        ForEach(colors, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(.menu)
                        
                        
                        //                Text("Selected color: \(selection)")
                    }.buttonStyle(.bordered).frame(width:500)
                }.padding(.top, 50)
                
                Button {
                } label: {
                    Image(systemName: "location.circle.fill").font(.system(size: 20, weight: .regular)).accentColor(Color.blue)
                   
                    Picker("Where are you going?", selection: $destination) {
                                    ForEach(des, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                    
                    
                    //                Text("Selected color: \(selection)")
                }.frame(width:500).buttonStyle(.bordered)
                
                Spacer()
             
                
                // Load and display an animated GIF using Kingfisher
                KFImage(URL(string: "https://i.gifer.com/origin/f5/f5baef4b6b6677020ab8d091ef78a3bc.gif")!).resizable().frame(width: 300, height: 350).scaledToFit().padding()

//                Spacer()
                // cycle through many messages
                Text("Good morning today!").bold().padding()
                Spacer()

            }.padding()
//            .navigationTitle(Text(title))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    HStack (spacing: 50){
                        Button(action: {
                            NotificationCenter.default.post(name: .displayBurgerMenu, object: nil)
                        }) {
                            
                            Image(systemName: "menucard.fill").accentColor(Color.blue).font(.system(size: 20, weight: .regular))
                        }
                        
                        Spacer()
                        // change font or replace w logo
                        Text("WATway").frame(maxWidth: .infinity, alignment: .center).accentColor(Color.black).font(.largeTitle) .fontWeight(.bold)
                
                        
                        Button{
                            //Action
                            self.showGuideView.toggle()
                        } label: {
                            Image(systemName: "info.circle").font(.system(size: 20, weight: .regular))
                        }.accentColor(Color.gray)
                            .sheet(isPresented: $showGuideView) {
                            GuideView()
                        }
                        // figure out why not at the end
                        // edit guideview
                    }
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainPage: View {
    @State var isBurgerMenuDisplayed = false
    @State var selectedMenuItem = 1
    @State var showGuide = false
    
//    @Binding var showGuideView: Bool
    
    var body: some View {
        
        HStack {
            
            ZStack {
                if selectedMenuItem == 1 {
                    HamburgMenu(title: "Navigation 1", showGuideView: $showGuide)
                        .allowsHitTesting(!isBurgerMenuDisplayed)
                } else {
                    HamburgMenu(title: "Navigation 2", showGuideView: $showGuide)
                        .allowsHitTesting(!isBurgerMenuDisplayed)
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.black.opacity(isBurgerMenuDisplayed ? 0.5 : 0))
                        .animation(.easeOut(duration: 0.3))
                        .onTapGesture {
                            NotificationCenter.default.post(name: .hideBurgerMenu, object: nil)
                        }
                    
                    List {
                        Section(header: VStack {
                            Text("Menu")
                                .font(.title.bold())
                                .frame(height: 100)
                        }) {
                            ForEach(1...2, id: \.self) { val in
                                Button(action: {
                                    selectedMenuItem = val
                                    NotificationCenter.default.post(name: .hideBurgerMenu, object: nil)
                                }) {
                                    Text("Navigation \(val)")
                                }
                            }
                        }
                        
                    }
                        .frame(width: 280)
                        .frame(maxHeight: .infinity)
                        .offset(x: isBurgerMenuDisplayed ? 0 : -200, y: 0)
                        .animation(.easeOut(duration: 0.3))
                }
                .allowsHitTesting(isBurgerMenuDisplayed)
                .accessibilityAddTraits(.isModal)
                .opacity(isBurgerMenuDisplayed ? 1 : 0)
                .animation(isBurgerMenuDisplayed ? .none : .easeOut(duration: 0.3))
            }
            .onReceive(NotificationCenter.default.publisher(for: .hideBurgerMenu)) { _ in
                isBurgerMenuDisplayed = false
            }
            .onReceive(NotificationCenter.default.publisher(for: .displayBurgerMenu)) { _ in
                isBurgerMenuDisplayed = true
            }
        }
        
      
    }
}

struct Hamburg_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//                ForEach(0...20, id: \.self) { val in
//                    NavigationLink(
//                        destination: Text("Detail \(val)").navigationTitle(Text("Detail"))) {
//                            Text("Go to \(val)")
//                        }
//                }
