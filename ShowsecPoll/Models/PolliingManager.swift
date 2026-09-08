//
//  PolliingManager.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 07/09/2026.
//

import SwiftUI

@Observable
class PollingManager  {
    private var isPolling: Bool = false
 
    var receiveddata: String = "loading..."
    let boundary = "---------B4EBB869-A29D-4DA3-B962-6F23FE749076"
    let accra = "KwablahAwadzi"
    let zanzibar = "yyAuTS6LLQ2ofXRUZxUnTCPc06EEb+Q7TJDcujU89bA="
    var bearerToken: String = ""
    var isLoggedIn: Bool = false
    var jobsList: JobDataList?
    var isRefreshing: Bool = false
    
    var sleepTimeInSeconds: Int
    
    init(sleepTimeInSeconds: Int) {
        self.sleepTimeInSeconds = sleepTimeInSeconds
    }
    
    func startPolling() {
        guard !isPolling else { return }
        isPolling = true
        
        
        
        Task {
         while isPolling {
             
              if isLoggedIn == false {
                  print("logging in...")
                  await login()
                  print("bearer token: \(self.bearerToken)")
                  if !self.bearerToken.isEmpty {
                      print("logged in")
                      self.isLoggedIn = true
                  } else {
                      print("problems logging in. quitting")
                      return
                  }
                }
                isRefreshing = true
                await fetchNetowrkData()
                isRefreshing = false
                try await Task.sleep(for: .seconds(sleepTimeInSeconds))
            }
                      
        }
    }
    
    func stopPolling() {
        isPolling = false
    }
    
     func login() async {
         let loginURLString = "https://publicapi.smartg8.com/Authentication/JWTLogin"
         let initialBoundary = Data("--\(boundary)\r\n".utf8)
         let intermediaryBoundary = Data("\r\n--\(boundary)\r\n".utf8)
         let closingBoundary = Data("\r\n--\(boundary)--\r\n".utf8)
         let initialBoundaryString = "\(boundary)"
               
         
        
         var request = URLRequest(url: URL(string: loginURLString)!)
         request.httpMethod = "POST"
         
         request.setValue("publicapi.smartg8.com", forHTTPHeaderField: "Host")
         request.setValue("application/json,text/json,text/x-json,text/javascript,application/xml,text/xml", forHTTPHeaderField: "Accept")
         request.setValue("showsec", forHTTPHeaderField: "Company")
         request.setValue("RestSharp/106.12.0.0", forHTTPHeaderField: "User-Agent")
         request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
         request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
         request.setValue("multipart/form-data; boundary=\(initialBoundaryString)", forHTTPHeaderField: "Content-Type")
   
        
         var data = Data()
         data.append(initialBoundary)
         data.append(Data("Content-Disposition: form-data; name=\"username\"\r\n\r\n".utf8))
         data.append(accra.data(using: .utf8)!)
         data.append(intermediaryBoundary)
         data.append(Data("Content-Disposition: form-data; name=\"password\"\r\n\r\n".utf8))
         data.append(zanzibar.data(using: .utf8)!)
         data.append(closingBoundary)
         request.setValue(data.count.description, forHTTPHeaderField: "Content-Length")
         
       //  let body: [String: String] = ["username" : username, "password" : password]
       //  request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
         request.httpBody = data
        
         request.debugPrint()
         
         do {
             let (resultdata,response) =  try await URLSession.shared.data(for: request)
             guard let httpResponse = response as? HTTPURLResponse else { return }
             print("status code: \(httpResponse.statusCode)")
                          
             self.receiveddata =  String(data: resultdata, encoding: .utf8) ?? "no data"
             if httpResponse.statusCode == 200 {
                 self.bearerToken = self.receiveddata
             }
  
         } catch {
             print(error)
         }
      
         

         
               
    }
    
    private func fetchNetowrkData() async {
        let dataURL = "https://publicapi.smartg8.com/project/upcoming"
        
       
               
        var request = URLRequest(url: URL(string: dataURL)!)
        request.httpMethod = "GET"
        
        request.setValue("publicapi.smartg8.com", forHTTPHeaderField: "Host")
        request.setValue(bearerToken, forHTTPHeaderField: "Bearer")
        request.setValue("application/json,text/json,text/x-json,text/javascript,application/xml,text/xml", forHTTPHeaderField: "Accept")
        request.setValue("showsec", forHTTPHeaderField: "Company")
        request.setValue("RestSharp/106.12.0.0", forHTTPHeaderField: "User-Agent")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
        request.debugPrint()
        
                
        do {
            let (resultdata,response) =  try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("status code: \(httpResponse.statusCode)")
                         
            self.receiveddata =  String(data: resultdata, encoding: .utf8) ?? "no data"
            if httpResponse.statusCode == 200 {
            
                do {
                    let json =  try JSONDecoder().decode(JobDataList.self, from: resultdata)
                    self.jobsList = json
                    self.jobsList!.Data[0].debugLog()
                } catch {
                    print(error)
                    fatalError(error.localizedDescription)
                }
             } else if httpResponse.statusCode == 401 {
                print("Unauthorized")
                self.isLoggedIn = false
            }
 
        } catch {
            print(error)
        }
    }
    
}

fileprivate extension URLRequest {
    func debugPrint() {
        print("\(self.httpMethod ?? "") \(self.url?.absoluteString ?? "")")
        print("headers:")
        print(self.allHTTPHeaderFields!)
        print("body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
    
}
