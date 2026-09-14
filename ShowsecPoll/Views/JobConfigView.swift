//
//  GameParametersView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 14/09/2026.
//



import SwiftUI

struct JobConfigView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding private var pollingIntervalInSeconds: Int
    @Binding private var cities: String
    @Binding private var isCancelled: Bool
    
   
    init(pollingIntervalInSeconds: Binding<Int>, cities: Binding<String>, isCancelled: Binding<Bool>) {
        self._pollingIntervalInSeconds = pollingIntervalInSeconds
        self._cities = cities
        self._isCancelled = isCancelled
    }
    
    let frameWidth: CGFloat = UIScreen.main.bounds.width
    let frameHeight: CGFloat = 400

    
    var disableOk: Bool {
        pollingIntervalInSeconds == 0 
       }
  
    var body: some View {
 
        VStack {

                HStack {
                    Text("Polling interval in secs:")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .padding(.leading,50)
                        .frame(width: 300, alignment: .leading)
                        .font(.title2)

                    TextField(
                                "",
                                value: $pollingIntervalInSeconds,
                                format: .number
                            )
                    .font(.title2)
                     }
                    VStack {
                        HStack {
                            Text("List of cities:")
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .padding(.leading,50)
                                .frame(width: 300, alignment: .leading)
                                .font(.title2)
                            
                            Spacer()
                            
                      
                        }
                        
                        VStack {
                            TextEditor(text: $cities)
                                .font(.title2)
                                .foregroundColor(Color.black)
                                .font(.custom("HelveticaNeue", size: 20))
                                .disableAutocorrection(true)
                               .frame(height: max(50,100)).border(.gray)
                                .cornerRadius(5.0)
                                .padding()
                        
                        }
                        
                                           
                        
                    } .frame(width: 400, alignment: .leading)
                        
                    Spacer().frame(height: 50)
            
                    HStack {
     
                            Button("OK") {
                                 isCancelled = false
                                 dismiss()
                            }
                            .padding(.leading,100)
                            .disabled(disableOk)
                            .buttonStyle(.borderedProminent)
                            .font(.title2)
                        Spacer().frame(width: 180)
                        Button("Cancel", role: .destructive) {
                               isCancelled = true
                                dismiss()
                            }
                            .font(.title2)
                            .padding(.trailing,50)
                            .buttonStyle(.borderedProminent)
                     
                    }  .frame(width: 500, alignment: .leading)
            }
            

     
            .frame(width: frameWidth, height: frameHeight, alignment: .center)
            .transition(
                               .asymmetric(
                                insertion: .move(edge: .top),
                                removal: .move(edge: .bottom)
                               )
                              )
            .background(Color.white)
            .cornerRadius(20)
        
         

    }
}

#Preview {
    JobConfigView(pollingIntervalInSeconds:  .constant(10), cities: .constant("London,Wembley"), isCancelled: .constant(false))
}
