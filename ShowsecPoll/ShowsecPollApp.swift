//
//  ShowsecPollApp.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI

@main
struct ShowsecPollApp: App {
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) {oldPhase, newPhase in
            switch newPhase {
            case .background:
                sheculeJobRefresh()
            default:
                break
            }
        }
        .backgroundTask(.appRefresh("showsecpoll.com.refreshjobs")) {
            await refreshJobs()
          }
    }
}
