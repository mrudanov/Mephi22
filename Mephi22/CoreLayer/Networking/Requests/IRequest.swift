//
//  IRequest.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import Alamofire

protocol IRequest {
    var urlString: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}
