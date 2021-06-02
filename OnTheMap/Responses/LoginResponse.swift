//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/1/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let key: String?
    let registered: Bool
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
