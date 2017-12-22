//
//  Mephi22Request.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import Alamofire

enum Mephi22RequestObject: String {
    case students, groups
}

enum Mephi22RequestType: String {
    case get, set
}

class Mephi22Request: IRequest {
    private let baseUrl: String = "https://mephi22.ru/api/"
    private let requestType: String
    private let requestObject: String
    private let requsetParameter: String?
    
    // MARK: - IRequest
    var urlString: String {
        if let requsetParameter = requsetParameter {
            return baseUrl + requestType + "/" + requestObject + "/" + requsetParameter
        } else {
            return baseUrl + requestType + "/" + requestObject
        }
    }
    
    var parameters: Parameters? = nil
    
    var headers: HTTPHeaders? = nil
    
    // MARK: - Initialization
    init(type: Mephi22RequestType, object: Mephi22RequestObject, parameter: String?) {
        requestType = type.rawValue
        requestObject = object.rawValue
        requsetParameter = parameter
    }
}
