//
//  JobData.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 08/09/2026.
//

import SwiftUI


class JobDataList: Identifiable, Hashable,Equatable,Codable  {
    
    var Result: Bool
    var ResultCode: Int
    var ListCount: Int
    var Data: [JobData]
    var ListCountUnopened: String?
    
    init(Result: Bool, ResultCode: Int, ListCount: Int, Data: [JobData], ListCountUnopened: String?) {
        self.Result = Result
        self.ResultCode = ResultCode
        self.ListCount = ListCount
        self.Data = Data
        self.ListCountUnopened = JobDataList.nullToNil(ListCountUnopened) as? String
    }

    static func == ( lhs: JobDataList, rhs: JobDataList) -> Bool {
        return lhs.Data == rhs.Data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Data)
    }

    static func nullToNil(_ value: Any?) -> Any? {
        return value as? String == "null" ? nil : value
    }
}

class JobData: Identifiable, Hashable,Equatable,Codable  {
    
   
    var DayParts: String
    var DayNames: String
    var ImageUrl: String
    var IsAvailableInCalendar: Int
    var Id: String
    var VenueId: String
    var EventDateStart: String
    var EventDateEnd: String
    var Name: String
    var Venue: String
    var City: String
    var WorkType: String
    var Sector: String
    var SectorId: String
    var Tags: [String]
    
    
    init(DayParts: String, DayNames: String, ImageUrl: String, IsAvailableInCalendar: Int, Id: String, VenueId: String, EventDateStart: String, EventDateEnd: String, Name: String, Venue: String, City: String, WorkType: String, Sector: String, SectorId: String, Tags: [String]) {

        self.DayParts = DayParts
        self.DayNames = DayNames
        self.ImageUrl = ImageUrl
        self.IsAvailableInCalendar = IsAvailableInCalendar
        self.Id = Id
        self.VenueId = VenueId
        self.EventDateStart = EventDateStart
        self.EventDateEnd = EventDateEnd
        self.Name = Name
        self.Venue = Venue
        self.City = City
        self.WorkType = WorkType
        self.Sector = Sector
        self.SectorId = SectorId
        self.Tags = Tags
    }
    
    
    static func == ( lhs: JobData, rhs: JobData) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Id)
    }
    
    func debugLog() {
        print(Mirror(reflecting: self).children.compactMap { "\($0.label ?? "unknown label"): \($0.value)" }.joined(separator: "\n"))
    }
        
     
    static var SampleData: [JobData] = [.init(DayParts: "Afternoon,Morning,Night", DayNames: "FRI,MON,SAT,SUN,THU,TUE,WEN", ImageUrl: " https://publicapi.smartg8.com/project/image/?projectId=0DF7FCA1-8F8A-4713-A2E3-7B4E98497457&company=showsec", IsAvailableInCalendar: 47, Id: "0DF7FCA1-8F8A-4713-A2E3-7B4E98497457", VenueId: "CD19829D-816C-496D-A8A7-CD7E0AE4F76D", EventDateStart: "2026-09-07 00:00:00", EventDateEnd: "2026-09-18 00:00:00", Name: " Big Retreat festival September 2026", Venue: "Big Retreat - Cambridgeshire", City: "Cambridgeshire", WorkType: "Female Steward,SIA Door Licenc...,SIA Door Licence,Steward,Steward Female,Supervisor,Supervisor control", Sector: "Entertainment Outdoor", SectorId: "4EDCD625-C45A-4E32-9DA4-CC3F062ACCB0", Tags: ["Female Steward", "STEWARD", "SIA Door Licenc...", "SIA", "SIA Door Licence", "Steward", "Steward Female", "Supervisor", "SUPERVISOR", "Supervisor control ", "Afternoon", "Morning", "Night", "FRI", "MON", "SAT", "SUN", "THU", "TUE", "WEN", "Entertainment Outdoor", "4EDCD625-C45A-4E32-9DA4-CC3F062ACCB0"])]
}
