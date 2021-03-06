//
//  GroupsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 10/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class GroupsDataSource: IGroupsDataSource {
    private struct GroupDataModel {
        var groupId: String
        var groupName: String?
    }
    
    weak var delegate: GroupsDataSourceDelegate?
    private let service: IMephi22Service
    private var groups: [GroupDataModel] = []
    
    // MARK: - Initialization
    init(service: IMephi22Service) {
        self.service = service
    }
    
    // MARK: - IGroupsDataSource protocol
    func getGroups() {
        groups = []
        service.getGroups { [weak self] groupsResult, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedGroupLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let groupsResult = groupsResult else {
                self?.delegate?.recievedGroupLoadError(errorMessage: "No data recieved!")
                return
            }
            
            for group in groupsResult {
                self?.groups.append(GroupDataModel(groupId: String(group.groupId), groupName: group.groupName))
            }
            self?.delegate?.groupsDidUpdate()
        }
    }
    
    func groupNameAt(_ index: Int) -> String {
        guard index < numberOfGroups() else { return "Unknown" }
        return groups[index].groupName ?? "Unknown"
    }
    
    func groupIdAt(_ index: Int) -> String {
        guard index < numberOfGroups() else { return "Unknown" }
        return groups[index].groupId
    }
    
    func numberOfGroups() -> Int {
        return groups.count
    }
}
