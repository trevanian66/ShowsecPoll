//
//  ContentView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var pollManager = PollingManager()
    let logFont = Font.system(size: 22, weight: .medium, design: .default)
    var body: some View {
        VStack {

            Text("Latest Server Status").font(logFont).fontWeight(.bold)
            ScrollView {
                Text(pollManager.receiveddata).font(logFont)
            }
        }
        .padding()
        .onAppear {
            pollManager.startPolling()
        }
        .onDisappear {
            pollManager.stopPolling()
        }
    }
}

#Preview {
    ContentView()
}
