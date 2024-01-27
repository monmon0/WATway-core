//
//  ContentView.swift
//  SwiftUIBurgerMenu
//
//  Created by Florent Morin on 02/06/2021.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI

extension Notification.Name {
    static let displayBurgerMenu = Self.init("DisplayBurgerMenuNotification")
    static let hideBurgerMenu = Self.init("HideBurgerMenuNotification")
}

let backgroundVar = Color.yellow

struct HamburgMenu: View {
    var title: String = "Navigation"
    
    // make  a list of selections seperately
    @State private var selection = "Where are you going?"
       let location = ["Where are you at?", "DC (Ring Road/ Near E7)", "MC", "SLC", "QNC", "E7(Ring Road)"]
    
    @State private var destination = "Where are you going?"
       let des = ["Where are you heading?", "DC (Ring Road/ Near E7)", "MC", "SLC", "QNC", "E7(Ring Road)"]

    // call function to get time here
    @State private var time = "0"
    
    @Binding var showGuideView: Bool
    
    @State private var test1 = false
    @State private var test2 = false
//    @Binding var showDirections: Bool
   
    var body: some View {
        NavigationView {
            // pretty useful maybe can make it into instructions later
            ZStack{
                backgroundVar
                VStack{
                    HStack {
                        Button {
                            withAnimation{
                                test2 = true
                            }
                        } label: {
                            Image(systemName: "mappin.and.ellipse").font(.system(size: 20, weight: .regular)).accentColor(Color.black)
                            
                            Picker("Where are you going?", selection: $selection) {
                                ForEach(location, id: \.self) {
                                    Text($0).fontWeight(.bold)
                                }
                            }
                            .pickerStyle(.menu).frame(maxWidth: .infinity)
                            .accentColor(Color.white)
                            
                        }.buttonStyle(.borderedProminent).padding()
                            .accentColor(Color.black)
                    }.padding(.top, 110)
                    

                    Button{
                        withAnimation{
                            test1 = true
                        }
                        
                    } label: {
                        Image(systemName: "location.circle.fill").font(.system(size: 20, weight: .regular)).accentColor(Color.black)
                        
                        Picker("Where are you heading?", selection: $destination) {
                            ForEach(des, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color.white)
                        .frame(maxWidth: .infinity)
                        
                    }.buttonStyle(.borderedProminent)
                        .accentColor(Color.blue).padding()
                    
                    AnimatedImage(url: URL(string: "https://i.gifer.com/origin/f5/f5baef4b6b6677020ab8d091ef78a3bc.gif"))
                    // Supports options and context, like `.progressiveLoad` for progressive animation loading
                        .onFailure { error in
                            // Error
                        }
                        .resizable()
                        .placeholder(UIImage(systemName: "photo")).frame(width: 300, height: 350).scaledToFit().padding()
                    
                    //                Spacer()
                    // cycle through many messages
                    Text(test1 ? "Have a waddly good day!" : test2 ? "What's way you waddling today?": "Welcome").transition(.slide).bold().padding().background(Color.white)
                        .cornerRadius(25)
                    
                    Spacer()
                    //Footer
                    // hide wen the input its not put in yet
                    
                    
                    if test1 && test2 {
                        VStack{
                         Spacer()
                         Footer(location: $destination, time:$time).padding() }
                                               .background(Color.white)
                                               .cornerRadius(25)
                                               
                                               .transition(.move(edge: .bottom))
                        
                        // make transition works
                    }
                }
            }.ignoresSafeArea()
        
//            .navigationTitle(Text(title))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    HStack (alignment: .center, spacing: 80){
                        Button(action: {
                            NotificationCenter.default.post(name: .displayBurgerMenu, object: nil)
                        }) {
                            
                            Image(systemName: "gearshape.fill").accentColor(Color.black).font(.system(size: 20, weight: .regular))
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
    @State var showDirections = false
    
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
                            NotificationCenter.default.post(name: .hideBurgerMenu, object: nil)}
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
        }.background(Color.yellow).ignoresSafeArea()
    }
}

struct Hamburg_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

