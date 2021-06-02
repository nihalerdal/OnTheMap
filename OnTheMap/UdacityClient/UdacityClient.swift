//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/1/21.
//

import Foundation

class UdacityClient {
    
    
     struct Auth {
       static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        
        case createSessionId
        
            
        var stringValue: String{
            switch self {
            case .createSessionId: return "https://onthemap-api.udacity.com/v1/session"
        
            }
        
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func login(username:String, password: String, completion: @escaping (Bool, Error?)-> Void ){
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"username\", \"password\": \"password\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    Auth.accountKey = responseObject.account.key ?? ""
                    Auth.sessionId = responseObject.session.id ?? ""
                    completion(responseObject.account.registered, nil)
                }
              
            }catch{
                DispatchQueue.main.async {
                    completion(false, error)
                }
               
            }
            
//            let range = (5..<data.count)
//            let newData = data.subdata(in: range) /* subset response data! */
//            print(String(data: newData, encoding: .utf8)!)
//            completion(true, nil)
        }
        task.resume()
    }
}

