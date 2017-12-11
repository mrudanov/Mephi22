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
}
