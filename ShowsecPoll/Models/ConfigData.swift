//
//  ConfigData.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 14/09/2026.
//

import Foundation
import SwiftUI


struct ConfigData: Codable, Hashable  {
    
    var pollingIntervalInSeconds: Int
    var cities: String
    var alreadySeenJobs: [String]
    
    
    init(pollingIntervalInSeconds: Int, cities: String, alreadySeenJobs: [String] = []) {
        self.pollingIntervalInSeconds = pollingIntervalInSeconds
        self.cities = cities
        self.alreadySeenJobs = alreadySeenJobs
    }
    
    
    func saveConfig() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        UserDefaults.standard.set(data, forKey: "config")
        
    }
    
    static func loadConfig() -> ConfigData? {
        
        var result: ConfigData?
        
        guard let data = UserDefaults.standard.data(forKey: "config") else { return nil }
        if let json = try? JSONDecoder().decode(ConfigData.self, from: data) {
            result = json
        }
                
        return result
        
    }
}

