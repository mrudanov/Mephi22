//
//  RequestSender.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import Alamofire

protocol IRequestSender {
    func send<Model: Codable>(request: IRequest, method: RequestMethod, completionHandler: @escaping (Result<Model>) -> Void)
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

enum RequestMethod {
    case get, post
}

class RequestSender: IRequestSender {
    func send<Model: Codable>(request: IRequest, method: RequestMethod, completionHandler: @escaping (Result<Model>) -> Void) {
        var alamofireMethod = HTTPMethod.get
        
        switch method {
        case .post:
            alamofireMethod = HTTPMethod.post
        default:
            alamofireMethod = HTTPMethod.get
        }
        
        Alamofire.request(request.urlString,
                          method: alamofireMethod,
                          parameters: request.parameters,
                          encoding: JSONEncoding.default,
                          headers: request.headers).responseData() { response in
            
            switch response.result {
            case .success:
                if let parseData = response.result.value {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let model = try jsonDecoder.decode(Model.self, from: parseData)
                        completionHandler(Result.success(model))
                    }
                    catch {
                        completionHandler(Result.error("Error getting response"))
                    }
                } else {
                    completionHandler(Result.error("No data recieved!"))
                }
            case .failure(let error):
                completionHandler(Result.error(error.localizedDescription))
            }
        }
    }
}
