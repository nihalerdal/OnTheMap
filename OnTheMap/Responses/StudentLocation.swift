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
    let ACL: String
}
