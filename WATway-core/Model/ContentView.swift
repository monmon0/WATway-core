//
//  ContentView.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-21.
//

import SwiftUI

struct ContentView: View {
    
    @State var showGuide: Bool = false
    @State var showMenu: Bool = false
  
    
    var body: some View {
        
            VStack{
                
//                Header(showGuideView: $showGuide, presentSideMenu: $showMenu)

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


//@GestureState private var dragState = DragState.inactive
//private var dragAreaThreshold: CGFloat = 65.0
//@State private var lastCardIndex: Int = 1
//@State var cardViews: [CardView] = {
//    var views = [CardView]()
//    for index in 0..<2 {
//        views.append(CardView(people: uwmeData[index]))
//    }
//    return views
//}()
//
//// Move the card
//private func moveCards() {
//    cardViews.removeFirst()
//
//    self.lastCardIndex += 1
//
//    let people = uwmeData[lastCardIndex % uwmeData.count]
//
//    let newCardView = CardView(people: people)
//
//    cardViews.append(newCardView)
//}
//
//// Top card
//private func isTopCard(cardView: CardView) -> Bool {
//    guard let index = cardViews.firstIndex(where: {$0.id == cardView.id}) else {
//        return false
//    }
//    return index == 0
//}
//
//enum DragState {
//    case inactive
//    case pressing
//    case dragging(translation: CGSize)
//
//    var translation: CGSize {
//        switch self {
//        case .inactive, .pressing:
//            return .zero
//        case .dragging(let translation):
//            return translation
//        }
//    }
//    var isDragging: Bool {
//        switch self {
//        case .dragging:
//            return true
//        case .pressing, .inactive:
//            return false
//        }
//    }
//    var isPressing: Bool {
//        switch self {
//        case .pressing, .dragging:
//            return true
//        case .inactive:
//            return false
//        }
//    }
//}

//ZStack {
//    ForEach(cardViews) { cardView in
//        cardView
//            .zIndex(self.isTopCard(cardView: cardView) ? 1: 0)
//            .overlay(
//                ZStack {
//                    // X symbol
//                    Image(systemName: "x.circle").modifier(SymbolModifier())
//                        .opacity(self.dragState.translation.width <
//                                 -self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0) // if pass the drag threshold then go if not snapped back
//                    
//                    // Heart SYmbol
//                    Image(systemName: "heart.circle").modifier(SymbolModifier())
//                        .opacity(self.dragState.translation.width >
//                                 self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0) // if pass the drag threshold then go if not snapped back
//                }
//            )
//            .offset(x: self.isTopCard(cardView: cardView) ?
//                    self.dragState.translation.width : 0, y:
//                        self.isTopCard(cardView: cardView) ?
//                    self.dragState.translation.height : 0)
//            .scaleEffect(self.dragState.isDragging &&
//                         self.isTopCard(cardView: cardView) ?  0.85 : 1.0)
//            .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
//            .animation(.interpolatingSpring(stiffness: 120, damping: 120))
//            .gesture(LongPressGesture(minimumDuration: 0.01)
//                .sequenced(before: DragGesture())
//                .updating(self.$dragState,  body: {(
//                value, state, transaction) in
//                    switch value {
//                    case .first(true):
//                    state = .pressing
//                    case .second(true, let drag):
//                        state = .dragging(translation: drag? .translation ?? .zero)
//                    default:
//                        break
//                    }
//                })
//                    .onEnded({ (value) in
//                        guard case .second(true, let drag?) = value else {
//                            return
//                        }
//                        
//                        if drag.translation.width < -self.dragAreaThreshold ||
//                            drag.translation.width > self.dragAreaThreshold {
//                            self.moveCards()
//                        }
//                    })
//            )
//    }
//}
//.padding(.horizontal)
