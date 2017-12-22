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
        static func getGallariesRequest() -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .gallaries,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: nil)
        }
        
        static func getPersonsRequest(gallaryId: String) -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .persons,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func enrollRequest(subjectId: String, image: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .enroll,
                                 image: image,
                                 subjectId: subjectId,
                                 gallary: gallaryId)
        }
        
        static func recognizeFaceRequest(image: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .recognize,
                                 image: image,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func deleteGallaryRequest(_ gallaryId: String) -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .removeGallary,
                                 image: nil,
                                 subjectId: nil,
                                 gallary: gallaryId)
        }
        
        static func deletePersonRequest(subjectId: String, gallaryId: String) -> IRequest {
            return KairosRequest(appId: "fa41e8ac",
                                 appKey: "72487a887ee6d2afbe8b0ff0032d2a2e",
                                 type: .removePerson,
                                 image: nil,
                                 subjectId: subjectId,
                                 gallary: gallaryId)
        }
    }
}
