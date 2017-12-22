//
//  KairosRequest.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import Alamofire

enum KairosRequestType: String {
    case persons = "gallery/view"
    case gallaries = "gallery/list_all"
    case enroll = "enroll"
    case recognize = "recognize"
    case removePerson = "gallery/remove_subject"
    case removeGallary = "gallary/remove"
}

class KairosRequest: IRequest {
    private let baseUrl: String =  "https://api.kairos.com"
    private let typeString: String
    
    // MARK: - IRequest
    var urlString: String {
        return baseUrl + "/" + typeString
    }
    
    var parameters: Parameters?
    
    var headers: HTTPHeaders?
    
    // MARK: - Initialization
    init(appId: String, appKey: String, type: KairosRequestType, image: String?, subjectId: String?, gallary: String?) {
        self.typeString = type.rawValue
        
        headers = [
            "Content-Type": "application/json",
            "app_id": appId,
            "app_key": appKey
        ]
        
        parameters = [:]
        
        if let image = image {
            parameters?["image"] = image
        }
        
        if let subjectId = subjectId {
            parameters?["subject_id"] = subjectId
        }
        
        if let gallary = gallary {
            parameters?["gallery_name"] = gallary
        }
    }
}
