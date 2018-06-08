//
//  RequestFactory.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct Mephi22Requests {
        static func getGroupsRequest() -> IRequest {
            return Mephi22Request(type: .get, object: .groups, parameter: nil)
        }
        
        static func getStudentsOfGroupRequest(groupId: String) -> IRequest {
            return Mephi22Request(type: .get, object: .students, parameter: groupId)
        }
    }
    
    struct KairosRequests {
        static let appId: String = ""
        static let appKey: String = ""
        
        static func getGallariesRequest() -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .gallaries,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: nil)
        }
        
        static func getPersonsRequest(gallaryId: String) -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .persons,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func enrollRequest(subjectId: String, image: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .enroll,
                                 image: image,
                                 subjectId: subjectId,
                                 gallary: gallaryId)
        }
        
        static func recognizeFaceRequest(image: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .recognize,
                                 image: image,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func deleteGallaryRequest(_ gallaryId: String) -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .removeGallary,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func deletePersonRequest(subjectId: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: appId,
                                 appKey: appKey,
                                 type: .removePerson,
                                 image: nil,
                                 subjectId: subjectId,
                                 gallary: gallaryId)
        }
    }
}
