//
//  GetUserDataResponse.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/9/21.
//

import Foundation

struct GetUserDataResponse: Codable {
    
    let firstName : String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName  = "first_name"
        case lastName = "last_name"
    }
}
