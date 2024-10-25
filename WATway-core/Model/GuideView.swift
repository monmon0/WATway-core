//
//  Guide.swift
//  UwMe
//
//  Created by Monica Trinh on 2024-01-22.
//

import SwiftUI

struct GuideView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                //make this into a component later?
                HeaderComponents()
                
                
                Text("Discover your pick and match with your fellow students").fontWeight(.black).font(.largeTitle)
                    .foregroundColor(Color.pink).multilineTextAlignment(.center)
                
                Text("lorem ipsum texholder blah blah i just wanna kms aiyoooo okayprob long enuf! :3").lineLimit(nil).multilineTextAlignment(.center)
                
                Spacer(minLength: 10)
                
                VStack(alignment: .leading, spacing: 25) {
                    GuideComponents(title: "Directions", subtitle: "Press button", description: "This is a placeholder mf. Please just let the product live", icon: "arrow.uturn.backward.circle.fill")
                    
                    GuideComponents(title: "Dislike", subtitle: "Swipe Left", description: "This is a placeholder mf. Please just let the product live", icon: "x.circle")
                    
                    GuideComponents(title: "Like", subtitle: "Swipe Right", description: "This is a placeholder mf. Please just let the product live", icon: "heart.circle")
                    
                    GuideComponents(title: "Superlike", subtitle: "Press button", description: "This is a placeholder mf. Please just let the product live", icon: "star.circle")
                }
                
                Spacer(minLength: 10)
                
                Button(action:
                        {
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Continue".uppercased())
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Capsule().fill(Color.pink))
                        .foregroundColor(Color.white)
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.bottom, 30)
                .padding(.horizontal, 40)
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
