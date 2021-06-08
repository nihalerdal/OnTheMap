//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/2/21.
//

import Foundation

struct StudentLocation: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updatedAt: Date
    let ACL: String?
    
    init(objectId: String, uniqueKey: String?, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, createdAt: Date, updatedAt: Date, ACL: String?){
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.ACL = ACL
        
    }
}
