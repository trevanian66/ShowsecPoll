//
//  ContentView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    @State private var pollManager = PollingManager()
    let logFont = Font.system(size: 22, weight: .medium, design: .default)
    @State private var jobItems: [JobData] = []
    @State private var listId: Int = 0
    @State private var pollingIntervalInSeconds: Int = 30
    @State private var citiesToFlag: String = ""
    @State private var isCancelled: Bool = true
    @State private var countDownFrom: Date?
    @State private var countDownTo: Date?
    @State private var alreadySeenJobs: [String] = []
    @State private var flaggedJobs: [String] = []
    @State private var jobdetaisId: Int = 0
    

    
    var body: some View {
        
        
        let listView =
        List {
            ForEach($jobItems, id: \.self) { $jobItem in
                let isflagged = flagJob(job: jobItem)
                let color = isflagged ? Color.pink.opacity(0.7) : Color.white
                JobDetailsItemView(jobDetailsItem: jobItem, backgroundColor: color, alreadySeen: alreadySeenJobs.contains(jobItem.Id))
               .id(jobdetaisId)
               .onTapGesture {
                   if flaggedJobs.contains(jobItem.Id) && !alreadySeenJobs.contains(jobItem.Id) {
                       alreadySeenJobs.append(jobItem.Id)
                       jobdetaisId += 1
                   }
              }
            }
             
        }  .id(listId)
        
        let refreshingView =
             ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint:.blue))
            .font(.title2)
                
        NavigationStack {
            VStack {
                
                HStack {
                    
                    Text("jobs: \(jobItems.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if pollManager.isRefreshing {
                        refreshingView
                    } else {
                        if let countDownFrom = countDownFrom, let countDownTo = countDownTo {
                            Text(timerInterval: countDownFrom...countDownTo, countsDown: true )
                                .font(.title2)
                                .padding(.leading, 30)
                        }
                    }
                }
                
                if jobItems.isEmpty {
                    VStack {
                        Text("Recieved: \(pollManager.receiveddata)")
                    }.frame(width: 350, height: 400)
                        .background(Color.white)
                } else {
                    listView
                }
  
                
                Spacer().frame(height:20)
                
                HStack {
                    
                    Spacer().frame(width: 5)
                    
                    NavigationLink(destination:  JobConfigView(pollingIntervalInSeconds: $pollingIntervalInSeconds, cities: $citiesToFlag, isCancelled: $isCancelled))  {
                        Text("Config")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                            .padding(.all,10)
                            .background(Color.black.clipShape(.rect(cornerRadius: 15)))
                            .frame(width: 100, height: 30)
                        
                    }
                    .onChange(of: isCancelled) {
                        if isCancelled == false {
                            saveConfig()
                            listId += 1
                            isCancelled = true
                        }
                        
                    }
                    
                    Spacer()
                    
                    Button("Refresh") {
                        pollManager.stopPolling()
                        pollManager.startPolling()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding(.all,10)
                    .background(Color.black.clipShape(.rect(cornerRadius: 15)))
                    .frame(width: 100, height: 30)
                    
                    Spacer().frame(width: 5)
                    
                }
                
                
            }
            .background(Color.gray.opacity(0.1))
            .onAppear {
                loadConfig()
                pollManager.sleepTimeInSeconds = pollingIntervalInSeconds
                pollManager.startPolling()
            }
            .onDisappear {
                pollManager.stopPolling()
                saveConfig()
            }
            .onChange(of: pollingIntervalInSeconds) {
                pollManager.stopPolling()
                pollManager.sleepTimeInSeconds = pollingIntervalInSeconds
                pollManager.startPolling()
                
            }
            .onChange(of: pollManager.jobsList) {
                jobItems = pollManager.jobsList!.Data
                listId += 1
            }
            .onChange(of: pollManager.isRefreshing) {
                if pollManager.isRefreshing == false {
                    countDownFrom = .now
                    countDownTo = Calendar.current.date(byAdding: .second, value: pollingIntervalInSeconds, to: .now)!
                    
                }
           }
            .onChange(of: alreadySeenJobs) {
                saveConfig()
               // listId += 1
            }
  
        }
    }
    
    
    func loadConfig() {
        
        if let configData = ConfigData.loadConfig() {
            pollingIntervalInSeconds = configData.pollingIntervalInSeconds
            citiesToFlag = configData.cities
            alreadySeenJobs = configData.alreadySeenJobs
        } else {
            let configData = ConfigData(pollingIntervalInSeconds: 30, cities: "")
            configData.saveConfig()
        }
                
    }
    
    func saveConfig() {
        let configData = ConfigData(pollingIntervalInSeconds: pollingIntervalInSeconds, cities: citiesToFlag, alreadySeenJobs: alreadySeenJobs)
        configData.saveConfig()
    }
    
    func flagJob(job: JobData) -> Bool{
      //  print("CITIES: \(citiesToFlag) JOB: \(job.City)")
        let soundToPlay: SystemSoundID = 1304
        if  !citiesToFlag.isEmpty &&  citiesToFlag.lowercased().contains(job.City.lowercased().trimmingCharacters(in:.whitespacesAndNewlines)) && !alreadySeenJobs.contains(job.Id){
            
            if !flaggedJobs.contains(job.Id) {
                flaggedJobs.append(job.Id)
                AudioServicesPlaySystemSound(soundToPlay)
            }
         
            return true
        } else {
            return false
        }
        
    }
}

        
#Preview {
    ContentView()
}
