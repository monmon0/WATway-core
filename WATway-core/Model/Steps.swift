//
//  Steps.swift
//  WATway-core
//
//  Created by Monica Trinh on 2024-01-25.
//

import SwiftUI

struct Steps: View {
    var body: some View {
        VStack{
            ForEach(0...20, id: \.self) { val in
            NavigationLink(destination: Text("Detail \(val)").navigationTitle(Text("Detail"))) {
                Text("Go to \(val)")}}
        }
    }
}

struct Steps_Previews: PreviewProvider {
    static var previews: some View {
        Steps()
    }
}
