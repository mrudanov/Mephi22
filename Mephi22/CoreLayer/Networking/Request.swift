//
//  Request.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import Alamofire

protocol IRequest {
    var urlString: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

enum Mephi22RequestObject: String {
    case students
    case groups
}

enum Mephi22RequestType: String {
    case get
    case set
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
