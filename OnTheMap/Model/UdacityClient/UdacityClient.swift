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
        case getLocations
        case postLocation
        
            
        var stringValue: String{
            switch self {
            case .createSessionId: return "https://onthemap-api.udacity.com/v1/session"
            case .getLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
            case .postLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
                
            }
        
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    
    task.resume()
    
    return task
}
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable > (url:URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void ){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
            do {
        
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
}
    
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getLocations.url, responseType: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response)
            }else{
                completion([], error)
            }
        }
    }
    
    class func login(username:String, password: String, completion: @escaping (Bool, Error?)-> Void ){
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = ("{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}").data(using: .utf8)
        
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

