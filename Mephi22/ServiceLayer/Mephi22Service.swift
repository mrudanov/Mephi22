//
//  Mephi22Service.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IMephi22Service {
    func getGroups(completionHandler: @escaping([Group]?, String?) -> Void)
    func getStudents(groupId: String, completionHandler: @escaping ([Student]?, String?) -> Void)
}

class Mephi22Service: IMephi22Service {
    private let requestSender: IRequestSender
    
    // MARK: - Initialization
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - IMephi22Service protocol
    func getGroups(completionHandler: @escaping([Group]?, String?) -> Void) {
        let request = RequestsFactory.Mephi22Requests.getGroupsRequest()
        requestSender.send(request: request, method: .get) { (result: Result<[Group]>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let groups):
                completionHandler(groups, nil)
            }
        }
    }
    
    func getStudents(groupId: String, completionHandler: @escaping ([Student]?, String?) -> Void) {
        let request = RequestsFactory.Mephi22Requests.getStudentsOfGroupRequest(groupId: groupId)
        requestSender.send(request: request, method: .get) { (result: Result<[Student]>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let students):
                completionHandler(students, nil)
            }
        }
    }
}
