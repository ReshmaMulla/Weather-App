//
//  ServiceLayer.swift
//  Appointments
//
//  Created by Reshma on 01/18/21.
//  Copyright © 2021 Reshma Mulla. All rights reserved.
//

import Foundation
import UIKit

enum APIFailure: Error {
    case URLFormationFailed
    case InvalidURLResponse
    case InvalidData
    case DecodingFailure(error: Error)
    case Other(error: Error)
}

class ServiceLayer {
    
    class func request<T: Codable>(router: Router, completion: @escaping (Result< T, Error>) -> ()) {
        // 2.
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.subBase + router.path
        
        switch router.method {
        case .POST:
            //Not appending parameters to URL, as paramters will be present in request body
            print("")
        default:
            components.queryItemsDictionary = router.parameters
        }
        guard let url = components.url else {
            completion(.failure(APIFailure.URLFormationFailed))
            return
        }
        let request = buildRequest(from: router, url: url)
        let session = URLSession(configuration: .default)
        //print("Hitting Request - \(url),\nRequest_body: \(request.httpBody.toString())")
        let dataTask = session.dataTask(with: request) { data, response, error in
            //print("Response for Request - \(String(describing: router.path))\nData - \(String(describing: String(data: data ?? Data(), encoding: .utf8)))\nAPI_Error - \(String(describing: error))")
            // 5.
            guard error == nil else {
                completion(.failure(APIFailure.Other(error: error!)))
                return
            }
            guard response != nil else {
                completion(.failure(APIFailure.InvalidURLResponse))
                return
            }
            guard let data = data else {
                completion(.failure(APIFailure.InvalidData))
                return
            }
            // 6.
            do {
                let decoderObj = JSONDecoder()
                let responseObject = try decoderObj.decode(T.self, from: data)
                    completion(.success(responseObject))
            } catch {
                print("Error: \(String(describing: error))")
                completion(.failure(APIFailure.DecodingFailure(error: error)))
            }
        }
        dataTask.resume()
    }
   static func decode<T>(_ type: T.Type, from data: Data) -> Result<T, Error> where T : Decodable {
      do {
          let decoderObj = JSONDecoder()
          let responseObject = try decoderObj.decode(T.self, from: data)
          return .success(responseObject)
      } catch {
          print("Error: \(String(describing: error))")
          return .failure(APIFailure.DecodingFailure(error: error))
      }
    }

}


extension ServiceLayer {

    fileprivate class func buildRequest(from router: Router,url: URL) -> URLRequest {
         
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method.rawValue
        urlRequest.allHTTPHeaderFields = router.header
        do {
            
            switch router.method {
                case MethodType.GET:
                    return urlRequest
                default:
                    let data = try! JSONSerialization.data(withJSONObject: router.parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    if let json = jsonData {
                        urlRequest.httpBody = json.data(using: String.Encoding.utf8.rawValue)
                    }
                }
            
            return urlRequest
        }
     }
}


extension URLComponents{
    
    var queryItemsDictionary : [String:Any]{
        set (queryItemsDictionary){
            self.queryItems = queryItemsDictionary.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
        }
        get{
            var params = [String: Any]()
            return queryItems?.reduce([:], { (_, item) -> [String: Any] in
                params[item.name] = item.value
                return params
            }) ?? [:]
        }
    }
}

protocol DecoderType {
    func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: DecoderType { }
extension PropertyListDecoder: DecoderType { }
