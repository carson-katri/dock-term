//
//  ContentView.swift
//  DockTerm
//
//  Created by Carson Katri on 3/8/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var terminal: Terminal
    
    var body: some View {
        TextField("Type", text: $terminal.input, onCommit: {
            terminal.execute()
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
