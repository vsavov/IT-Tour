//
//  MainManager.swift
//  IT Tour
//
//  Created by Konstantin Bakalov on 8/3/15.
//  Copyright (c) 2015 IT Tour. All rights reserved.
//

import Foundation
import CoreData

typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<JSONDictionary>

class MainManager {
    
    static let sharedInstance = MainManager()
    
    static let hourDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        formatter.dateFormat = "HH"
        
        return formatter
    }()
    
    private static let parsingDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter
        }()
    
    func defaultConference() -> Conference? {
        return CoreDataManager.sharedInstance.defaultConference()
    }
    
    func presenterWithID(presenterID: Int) -> Presenter? {
        return CoreDataManager.sharedInstance.presenterWithID(presenterID)
    }
    
    func lectureWithID(lectureID: String) -> Lecture? {
        return CoreDataManager.sharedInstance.lectureWithID(lectureID)
    }
    
    func changeFavoriteStatusOf(lectureID: String) -> Lecture? {
        return CoreDataManager.sharedInstance.changeFavoriteStatusOf(lectureID)
    }
    
    func parseJSON() {
        let jsonPath = NSBundle.mainBundle().pathForResource("varnaConf_updated", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        
        var error: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.allZeros, error: &error) as? JSONDictionary
        
        if error != nil || json == nil {
            NSLog("Failed to parse JSON with ERROR: \(error)")
            return
        }
        
        ////////////////////////
        // Order DOES matter! //
        ////////////////////////
        self.parsePresentersJSON(json!["Presenters"] as! JSONArray)
        self.parseRoomsJSON(json!["Rooms"] as! JSONArray)
        self.parseConferencesJSON(json!["Conferences"] as! JSONArray, defaultConferenceID: json!["DefaultConferenceID"] as! NSNumber)
        
        CoreDataManager.sharedInstance.save()
    }
    
    func parseConferencesJSON(conferences: JSONArray, defaultConferenceID: NSNumber) {
        for conf in conferences {
            let confID = conf["ConferenceID"] as! NSNumber
            
            var conference = CoreDataManager.sharedInstance.conferenceWithID(confID.integerValue)
            
            if conference == nil {
                conference = NSEntityDescription.insertNewObjectForEntityForName("Conference", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Conference
                
                conference!.conferenceID = confID
            }
            
            conference!.conferenceName = conf["ConferenceName"] as! String
            conference!.logoURL = conf["LogoURL"] as! String
            conference!.startDate = self.dateFromString(conf["StartDate"] as! String)
            conference!.endDate = self.dateFromString(conf["EndDate"] as! String)
            conference!.isDefault = confID.integerValue == defaultConferenceID.integerValue
            
            let lectures = self.parseLecturesJSON(conf["Lectures"] as! JSONArray)
            
            conference!.lectures = NSSet(array: lectures)
        }
    }
    
    func parseLecturesJSON(lectures: JSONArray) -> [Lecture] {
        let context = CoreDataManager.sharedInstance.managedObjectContext
        
        var result: [Lecture] = Array()
        
        for lect in lectures {
            let lectureID = lect["LectureID"] as! String
            
            var lecture = CoreDataManager.sharedInstance.lectureWithID(lectureID)
            
            if lecture == nil {
                lecture = NSEntityDescription.insertNewObjectForEntityForName("Lecture", inManagedObjectContext: context) as? Lecture
                
                lecture!.lectureID = lectureID
            }
            
            lecture!.lectureName = lect["LectureName"] as! String
            lecture!.startTime = self.dateFromString(lect["StartTime"] as! String)
            lecture!.endTime = self.dateFromString(lect["EndTime"] as! String)
            
            if let roomID = lect["RoomID"] as? NSNumber {
                var fetchRequest = NSFetchRequest(entityName: "Room")
                fetchRequest.predicate = NSPredicate(format: "roomID == %@", roomID)
                
                let fetchedRooms = context.executeFetchRequest(fetchRequest, error: nil) as? [Room]
                
                if let room = fetchedRooms?.first {
                    lecture!.room = room
                }
            }
            
            if let presenterIDs = lect["PresenterIDs"] as? NSArray {
                var fetchRequest = NSFetchRequest(entityName: "Presenter")
                fetchRequest.predicate = NSPredicate(format: "presenterID IN %@", presenterIDs)
                
                let fetchedPresenters = context.executeFetchRequest(fetchRequest, error: nil) as? [Presenter]
                
                if let presenters = fetchedPresenters {
                    lecture!.presenters = NSSet(array: presenters)
                }
            }
            
            result.append(lecture!)
        }
        
        return result
    }
    
    func parsePresentersJSON(presenters: JSONArray) {
        for prt in presenters {
            let prtID = prt["PresenterID"] as! NSNumber
            
            var presenter = CoreDataManager.sharedInstance.presenterWithID(prtID.integerValue)
            
            if presenter == nil {
                presenter = NSEntityDescription.insertNewObjectForEntityForName("Presenter", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Presenter
                
                presenter!.presenterID = prtID
            }
            
            presenter!.firstName = prt["PresenterFirstName"] as! String
            presenter!.lastName = prt["PresenterLastName"] as! String
            presenter!.imageURL = prt["PresenterImageURL"] as! String
            presenter!.shortBio = prt["PresenterDescription"] as! String
        }
    }
    
    func parseRoomsJSON(rooms: JSONArray) {
        for rm in rooms {
            let rmID = rm["RoomID"] as! NSNumber
            
            var room = CoreDataManager.sharedInstance.roomWithID(rmID.integerValue)
            
            if room == nil {
                room = NSEntityDescription.insertNewObjectForEntityForName("Room", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Room
                
                room!.roomID = rmID
            }
            
            room!.roomName = rm["RoomName"] as! String
        }
    }
    
    func dateFromString(dateString: String) -> NSDate {
        return MainManager.parsingDateFormatter.dateFromString(dateString)!
    }
}
