//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 6/1/21.
//

import Foundation

class UdacityClient {
    
    struct User {
        static var location = ""
        static var link = ""
        static var createdAt = ""
        static var updatedAt = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        
    }
    
    enum Endpoints {
        
        case createSessionId
        case getLocations
        case postLocation
        case getUserData
        case updateLocation
        case logout
        case webAuth
        
            
        var stringValue: String{
            switch self {
            case .createSessionId: return "https://onthemap-api.udacity.com/v1/session"
            case .getLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
            case .postLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .getUserData: return "https://onthemap-api.udacity.com/v1/users/\(Auth.accountKey)"
            case .updateLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation/\(Auth.accountKey)"
            case .logout: return "https://onthemap-api.udacity.com/v1/session"
            case .webAuth: return "https://auth.udacity.com/sign-up"
                
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
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
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
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range)
                    print(String(data: newData, encoding: .utf8)!)
                    
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
}
    
    class func getUserData(completion: @escaping (String?, String?, Error?)-> Void){
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: GetUserDataResponse.self) { response, error in
            if let response = response {
                print("Getting user data was completed")
                completion(response.firstName, response.lastName, nil)
                User.firstName = response.firstName
                User.lastName = response.lastName
                print(response)
            }else{
                completion(nil, nil, error)
            }
        }
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
    
    
    class func postLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?)-> Void){
        
        let body = PostLocation(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoints.postLocation.url, responseType: PostLocationResponse.self, body: body) { response, error in
            if let response = response {
                User.createdAt = response.createdAt
                print(response.createdAt)
                completion(true, nil)
            }else{
                completion(false, error)
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
                    Auth.accountKey = responseObject.account.key ?? "no account key"
                    Auth.sessionId = responseObject.session.id ?? "no session id"
                    completion(responseObject.account.registered, nil)
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do{
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                _ = try JSONDecoder().decode(Session.self, from: newData)
                DispatchQueue.main.async {
                    Auth.sessionId = ""
                    completion(true, nil)
                }
             
            }catch{
                completion(false, error)
                print("Logout failed.")
            }
           
        }
        
        task.resume()
    }

    
    
    class func updateLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \(Auth.accountKey), \"firstName\":\(firstName), \"lastName\": \(lastName),\"mapString\": \(mapString), \"mediaURL\": \(mediaURL),\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(UpdateLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    User.updatedAt = responseObject.updatedAt
                    print("location updated")
                    completion(true, nil)
                }
                
            } catch {
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    let responseObject = try JSONDecoder().decode(UpdateLocationResponse.self, from: newData)
                    DispatchQueue.main.async {
                        User.updatedAt = responseObject.updatedAt
                        print("location updated")
                        completion(true, nil)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
        
    }
    
}
