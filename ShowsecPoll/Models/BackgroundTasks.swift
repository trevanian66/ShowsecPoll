//
//  BackgroundTasks.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 17/09/2026.
//

import BackgroundTasks
import AudioToolbox


func sheculeJobRefresh() {
    
    let request = BGAppRefreshTaskRequest(identifier: "showsecpoll.com.refreshjobs")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 10 * 60)
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("unable to scheulde background task. error is \(error)")
    }
    
}


func refreshJobs() async {
    
    let pollManager = PollingManager()

     if let joblist = await pollManager.getJobs() {
         
         if let configData = ConfigData.loadConfig() {
   
             let citiesToFlag = configData.cities
             let alreadySeenJobs = configData.alreadySeenJobs
             var flagjobs: Bool = false
             
             for i in 0..<joblist.Data.count {
                 let job = joblist.Data[i]
                 
                 if  !citiesToFlag.isEmpty &&  citiesToFlag.lowercased().contains(job.City.lowercased().trimmingCharacters(in:.whitespacesAndNewlines)) && !alreadySeenJobs.contains(job.Id){
                     flagjobs = true
                     
                     let notificationDate = Calendar.current.date(byAdding: .second, value: 10, to: .now)!
                     let notificationTitle = "New Job found in \(job.City)!".uppercased()
                     let notificationBody = "New job at \(job.Venue) in \(job.City) on \(job.EventDateStart.replacingOccurrences(of: "00:00:00", with: "")))"
                     
                     _ = await scheduleNotification(title: notificationTitle, body: notificationBody, identifier: job.Id, date: notificationDate)
                                          
                 }
             }
             
             if flagjobs {
                 AudioServicesPlaySystemSound(1304)
             }
         
         }
        
    }
    
}
