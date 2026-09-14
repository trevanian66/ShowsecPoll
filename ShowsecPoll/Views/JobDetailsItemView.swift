//
//  JobDetailsItemView.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 08/09/2026.
//

import SwiftUI

struct JobDetailsItemView: View {
    
    @State private var jobDetailsItem: JobData
    @State private var backgroundColor: Color
    @State private var alreadySeen: Bool
    let formFont = Font.system(size: 20, weight: .medium, design: .default)
    
    
    init(jobDetailsItem: JobData, backgroundColor: Color = .white, alreadySeen: Bool = false) {
        self.jobDetailsItem = jobDetailsItem
        self.backgroundColor = backgroundColor
        self.alreadySeen = alreadySeen
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(jobDetailsItem.Name)")
                    .font(formFont)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
                if  alreadySeen  {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .leading)
                }
            }
            
            
            HStack {
                Text("\(jobDetailsItem.Venue)")
                    .font(formFont)
                    .padding(.leading, 20)
                Spacer()
                
            }
            
            HStack {
                Text("\(jobDetailsItem.City)")
                    .font(formFont)
                    .foregroundStyle(Color.blue)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
                
      
                
            }
            
             HStack {
                 Text("start date: \(jobDetailsItem.EventDateStart)")
                     .font(formFont)
                     .padding(.leading, 20)
                 Spacer()
            }
       
            HStack {
                Text("end date \(jobDetailsItem.EventDateEnd)")
                    .font(formFont)
                    .padding(.leading, 20)
                Spacer()

            }
           
            
        }
        .background(backgroundColor)
    }
}

#Preview {
    JobDetailsItemView(jobDetailsItem: JobData.SampleData[0])
}
