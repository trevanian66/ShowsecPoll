//
//  ContentView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var pollManager = PollingManager(sleepTimeInSeconds: 30)
    let logFont = Font.system(size: 22, weight: .medium, design: .default)
    @State private var jobItems: [JobData] = []
    @State private var listId: Int = 0

    
    var body: some View {
        
        
        let listView =
        List {
            ForEach($jobItems, id: \.self) { $jobItem in
                JobDetailsItemView(jobDetailsItem: jobItem)
            }
             
        }  .id(listId)
        
        let refreshingView =
             ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint:.blue))
            .font(.title2)
                
        
        VStack {
            
            HStack {
                
                Text("jobs: \(jobItems.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if pollManager.isRefreshing {
                    refreshingView
                }
            }
            
            
            listView
                .onChange(of: pollManager.jobsList) {
                       jobItems = pollManager.jobsList!.Data
                       listId += 1
                    
                    
                }
        }
        .background(Color.gray.opacity(0.1))
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
