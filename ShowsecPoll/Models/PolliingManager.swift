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
    let sleepTimeInSeconds = 10.0
    var receiveddata: String = "loading..."
    let boundary = "-----------B4EBB869-A29D-4DA3-B962-6F23FE749076"
    let username = "KwablahAwadzi"
    let password = "yyAuTS6LLQ2ofXRUZxUnTCPc06EEb+Q7TJDcujU89bA="
    
    
    func startPolling() {
        guard !isPolling else { return }
        isPolling = true
        
        Task {
            
          await login()
            
        }
    }
    
    func stopPolling() {
        isPolling = false
    }
    
     func login() async {
         let loginURLString = "https://publicapi.smartg8.com/Authentication/JWTLogin"
         let initialBoundary = Data("\(boundary)\r\n".utf8)
         let intermediaryBoundary = Data("\r\n\(boundary)\r\n".utf8)
         let closingBoundary = Data("\r\n\(boundary)--\r\n".utf8)
         let initialBoundaryString = "\(boundary)"
        
         
        
         var request = URLRequest(url: URL(string: loginURLString)!)
         request.httpMethod = "POST"
         
        // request.setValue("publicapi.smartg8.com", forHTTPHeaderField: "Host")
         request.setValue("application/json,text/json,text/x-json,text/javascript,application/xml,text/xml", forHTTPHeaderField: "Accept")
         request.setValue("showsec", forHTTPHeaderField: "Company")
         request.setValue("RestSharp/106.12.0.0", forHTTPHeaderField: "User-Agent")
         request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
         request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
         request.setValue("multipart/form-data; boundary=\(initialBoundaryString)", forHTTPHeaderField: "Content-Type")
   
        
         var data = Data()
         data.append(initialBoundary)
         data.append(Data("Content-Disposition: form-data; name=\"username\"\r\n\r\n".utf8))
         data.append(username.data(using: .utf8)!)
         data.append(intermediaryBoundary)
         data.append(Data("Content-Disposition: form-data; name=\"password\"\r\n\r\n".utf8))
         data.append(password.data(using: .utf8)!)
         data.append(closingBoundary)
         request.setValue(data.count.description, forHTTPHeaderField: "Content-Length")
         
       //  let body: [String: String] = ["username" : username, "password" : password]
       //  request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
         request.httpBody = data
        
         request.debugPrint()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("status code: \(httpResponse.statusCode)")
            
            if let data = data {
                self.receiveddata =  String(data: data, encoding: .utf8) ?? "no data"
                print("DATA IS: \(self.receiveddata)")
            }
        }
        task.resume()
        
    }
    
    private func fetchNetowrkData() {
        
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
