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

public class MainManager {
    
    public static let sharedInstance = MainManager()
    
    public static let hourDateFormatter: NSDateFormatter = {
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
    
    public func defaultConference() -> Conference? {
        return CoreDataManager.sharedInstance.defaultConference()
    }
    
    public func presenterWithID(presenterID: Int) -> Presenter? {
        return CoreDataManager.sharedInstance.presenterWithID(presenterID)
    }
    
    public func lectureWithID(lectureID: String) -> Lecture? {
        return CoreDataManager.sharedInstance.lectureWithID(lectureID)
    }
    
    public func changeFavoriteStatusOf(lectureID: String) -> Lecture? {
        return CoreDataManager.sharedInstance.changeFavoriteStatusOf(lectureID)
    }
    
    public func loadDataFromServer() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            var url = NSURL(string: "http://appventures.co/itTour.json")!
            
            let jsonData = NSData(contentsOfURL: url)
            
            if let unwrappedJsonData = jsonData {
                var error: NSError?
                var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(unwrappedJsonData, options: NSJSONReadingOptions.allZeros, error: &error)
                
                if let jsonDictionary = json as? JSONDictionary {
                    self.parseJSON(jsonDictionary)
                }
            }
        })
    }
    
    public func getFavoriteLectures() -> [Lecture] {
        return CoreDataManager.sharedInstance.getFavoriteLectures()
    }
    
    private func parseJSON(json: JSONDictionary) {
        ////////////////////////
        // Order DOES matter! //
        ////////////////////////
        let presentersImageURLs = self.parsePresentersJSON(json["Presenters"] as! JSONArray)
        self.parseRoomsJSON(json["Rooms"] as! JSONArray)
        let conferenceImageURLs = self.parseConferencesJSON(json["Conferences"] as! JSONArray, defaultConferenceID: json["DefaultConferenceID"] as! NSNumber)
        
        CoreDataManager.sharedInstance.save()
        
        self.loadConferencesImagesFrom(conferenceImageURLs)
        self.loadPresentersImagesFrom(presentersImageURLs)
    }
    
    private func parseConferencesJSON(conferences: JSONArray, defaultConferenceID: NSNumber) -> [String] {
        var imageURLs: [String] = []
        
        for conf in conferences {
            let confID = conf["ConferenceID"] as! NSNumber
            
            var conference = CoreDataManager.sharedInstance.conferenceWithID(confID.integerValue)
            
            if conference == nil {
                conference = NSEntityDescription.insertNewObjectForEntityForName("Conference", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Conference
                
                conference!.conferenceID = confID
            }
            
            var conferenceName = conf["ConferenceName"] as? String
            
            if conferenceName != conference!.conferenceName {
                conference!.conferenceName = conferenceName
            }
            
            var logoURL = conf["LogoURL"] as? String
            
            if logoURL != conference!.logoURL {
                conference!.logoURL = logoURL
                conference!.image = nil
            }
            
            var startDate = self.dateFromString(conf["StartDate"] as? String)
            
            if startDate != conference!.startDate {
                conference!.startDate = startDate
            }
            
            var endDate = self.dateFromString(conf["EndDate"] as? String)
            
            if endDate != conference!.endDate {
                conference!.endDate = endDate
            }
            
            let isDefault = confID.integerValue == defaultConferenceID.integerValue
            
            if isDefault != conference!.isDefault {
                conference!.isDefault = isDefault
            }
            
            let lectures = self.parseLecturesJSON(conf["Lectures"] as! JSONArray)
            
            conference!.lectures = NSSet(array: lectures)
            
            if conference!.image == nil {
                if let imageURL = logoURL {
                    imageURLs.append(imageURL)
                }
            }
        }
        
        return imageURLs
    }
    
    private func parseLecturesJSON(lectures: JSONArray) -> [Lecture] {
        let context = CoreDataManager.sharedInstance.managedObjectContext
        
        var result: [Lecture] = Array()
        
        for lect in lectures {
            let lectureID = lect["LectureID"] as! String
            
            var lecture = CoreDataManager.sharedInstance.lectureWithID(lectureID)
            
            if lecture == nil {
                lecture = NSEntityDescription.insertNewObjectForEntityForName("Lecture", inManagedObjectContext: context) as? Lecture
                
                lecture!.lectureID = lectureID
            }
            
            var lectureName = lect["LectureName"] as? String
            
            if lectureName != lecture!.lectureName {
                lecture!.lectureName = lectureName
            }
            
            var startTime = self.dateFromString(lect["StartTime"] as? String)
            
            if startTime != lecture!.startTime {
                lecture!.startTime = startTime
            }
            
            var endTime = self.dateFromString(lect["EndTime"] as? String)
            
            if endTime != lecture!.endTime {
                lecture!.endTime = endTime
            }
            
            var videoURL = lect["VideoURL"] as? String
            
            if videoURL != lecture!.videoURL {
                lecture!.videoURL = videoURL
            }
            
            var presentationURL = lect["PresentationURL"] as? String
            
            if presentationURL != lecture!.presentationURL {
                lecture!.presentationURL = presentationURL
            }
            
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
    
    private func parsePresentersJSON(presenters: JSONArray) -> [String] {
        var imageURLs: [String] = []
        
        for prt in presenters {
            let prtID = prt["PresenterID"] as! NSNumber
            
            var presenter = CoreDataManager.sharedInstance.presenterWithID(prtID.integerValue)
            
            if presenter == nil {
                presenter = NSEntityDescription.insertNewObjectForEntityForName("Presenter", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Presenter
                
                presenter!.presenterID = prtID
            }
            
            var firstName = prt["PresenterFirstName"] as? String
            
            if firstName != presenter!.firstName {
                presenter!.firstName = firstName
            }
            
            var lastName = prt["PresenterLastName"] as? String
            
            if lastName != presenter!.lastName {
                presenter!.lastName = lastName
            }
            
            var imageURL = prt["PresenterImageURL"] as? String
            
            if imageURL != presenter!.imageURL {
                presenter!.imageURL = imageURL
                presenter!.image = nil
            }
            
            var shortBio = prt["PresenterDescription"] as? String
            
            if shortBio != presenter!.shortBio {
                presenter!.shortBio = shortBio
            }
            
            if presenter!.image == nil {
                if let imageURL = prt["PresenterImageURL"] as? String {
                    imageURLs.append(imageURL)
                }
            }
        }
        
        return imageURLs
    }
    
    private func parseRoomsJSON(rooms: JSONArray) {
        for rm in rooms {
            let rmID = rm["RoomID"] as! NSNumber
            
            var room = CoreDataManager.sharedInstance.roomWithID(rmID.integerValue)
            
            if room == nil {
                room = NSEntityDescription.insertNewObjectForEntityForName("Room", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as? Room
                
                room!.roomID = rmID
            }
            
            room!.roomName = rm["RoomName"] as? String
        }
    }
    
    private func dateFromString(dateString: String?) -> NSDate? {
        if let unwrappedDateString = dateString {
            return MainManager.parsingDateFormatter.dateFromString(unwrappedDateString)
        }
        
        return nil
    }
    
    private func loadPresentersImagesFrom(urls: [String]) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        let operationQueue = NSOperationQueue()
        operationQueue.underlyingQueue = queue
        operationQueue.maxConcurrentOperationCount = 1
        
        for urlString in urls {
            operationQueue.addOperationWithBlock({ () -> Void in
                let url = NSURL(string: urlString)!
                
                let imageData = NSData(contentsOfURL: url)
                
                if let unwrappedImageData = imageData {
                    var presenter = CoreDataManager.sharedInstance.presenterForImageURL(urlString)
                    
                    if let unwrappedPresenter = presenter {
                        let image = UIImage(data: unwrappedImageData)
                        
                        unwrappedPresenter.setImageData(image)
                        
                        CoreDataManager.sharedInstance.save()
                    }
                }
            })
        }
        
        operationQueue.addOperationWithBlock({ () -> Void in
            CoreDataManager.sharedInstance.save()
        })
    }
    
    private func loadConferencesImagesFrom(urls: [String]) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        let operationQueue = NSOperationQueue()
        operationQueue.underlyingQueue = queue
        operationQueue.maxConcurrentOperationCount = 1
        
        for urlString in urls {
            operationQueue.addOperationWithBlock({ () -> Void in
                let url = NSURL(string: urlString)!
                
                let imageData = NSData(contentsOfURL: url)
                
                if let unwrappedImageData = imageData {
                    var conference = CoreDataManager.sharedInstance.conferenceForImageURL(urlString)
                    
                    if let unwrappedConference = conference {
                        let image = UIImage(data: unwrappedImageData)
                        
                        unwrappedConference.setImageData(image)
                    }
                }
            })
        }
        
        operationQueue.addOperationWithBlock({ () -> Void in
            CoreDataManager.sharedInstance.save()
        })
    }
}
