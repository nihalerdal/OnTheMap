//
//  StudentLocationResults.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/2/21.
//

import Foundation

struct StudentLocationResults: Codable {
    let results: [StudentLocation]
    
    init(results: [StudentLocation]){
        self.results = results
        
    }
    
}
