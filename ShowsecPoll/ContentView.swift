//
//  ContentView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var pollManager = PollingManager()
    var body: some View {
        VStack {

            Text("Latest Server Status").font(.headline)
            Text(pollManager.receiveddata).font(.body)
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
