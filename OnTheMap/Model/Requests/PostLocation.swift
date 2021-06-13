//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/8/21.
//

import Foundation

struct PostLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
