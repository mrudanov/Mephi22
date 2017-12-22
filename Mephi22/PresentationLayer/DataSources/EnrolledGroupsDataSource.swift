//
//  EnrolledGroupsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class EnrolledGroupsDataSource: IGroupsDataSource {
    private struct GroupDataModel {
        var groupId: String
        var groupName: String?
    }
    
    weak var delegate: GroupsDataSourceDelegate?
    
    private let mephi22Service: IMephi22Service
    private let faceRecognitionService: IFaceRecognitionService
    
    private var allGroups: [GroupDataModel] = []
    private var enrollerdGroups: [GroupDataModel] = []
    
    private var enrolledGroupsRecieved: Bool = false
    private var allGroupsRecieved: Bool = false
    
    // MARK: - Initialization
    init(mephi22Service: IMephi22Service, faceRecognitionService: IFaceRecognitionService) {
        self.mephi22Service = mephi22Service
        self.faceRecognitionService = faceRecognitionService
    }
    
    // MARK: - IGroupsDataSource protocol
    func getGroups() {
        enrolledGroupsRecieved = false
        allGroupsRecieved = false
        
        getGroupsFromMephi22()
        getGeoupsFromFaceRecognitionSystem()
    }
    
    func groupNameAt(_ index: Int) -> String {
        return enrollerdGroups[index].groupName ?? "Unknown"
    }
    
    func groupIdAt(_ index: Int) -> String {
        return enrollerdGroups[index].groupId
    }
    
    func numberOfGroups() -> Int {
        return enrollerdGroups.count
    }
    
    // MARK: - helper function
    private func getGroupsFromMephi22() {
        mephi22Service.getGroups { [weak self] groupsResult, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedGroupLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let groupsResult = groupsResult else {
                self?.delegate?.recievedGroupLoadError(errorMessage: "No data recieved!")
                return
            }
            
            self?.updateAllGroups(groupsResult)
        }
    }
    
    private func getGeoupsFromFaceRecognitionSystem() {
        faceRecognitionService.getFacialGroups { [weak self] groupIds, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedGroupLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let groupIds = groupIds else {
                self?.delegate?.recievedGroupLoadError(errorMessage: "No data recieved!")
                return
            }
            
            self?.updateEnrolledGroups(groupIds)
        }
    }
    
    private func updateAllGroups(_ groupsToUpdate: [Group]) {
        DispatchQueue.main.async {
            self.allGroups = []
            self.allGroupsRecieved = true
            
            for group in groupsToUpdate {
                self.allGroups.append(GroupDataModel(groupId: String(group.groupId), groupName: group.groupName))
            }
            
            self.joinGroups()
        }
    }
    
    private func updateEnrolledGroups(_ groupsToUpdate: [String]) {
        DispatchQueue.main.async {
            self.enrollerdGroups = []
            self.enrolledGroupsRecieved = true
            
            for group in groupsToUpdate {
                self.enrollerdGroups.append(GroupDataModel(groupId: group, groupName: nil))
            }
            
            self.joinGroups()
        }
    }
    
    private func joinGroups() {
        if enrolledGroupsRecieved && allGroupsRecieved {
            for i in 0..<enrollerdGroups.count {
                for j in 0..<allGroups.count {
                    if allGroups[j].groupId == enrollerdGroups[i].groupId {
                        enrollerdGroups[i].groupName = allGroups[j].groupName
                    }
                    
                    if enrollerdGroups[i].groupId == "all" { enrollerdGroups[i].groupName = "All students" }
                }
            }
            
            delegate?.groupsDidUpdate()
        }
    }
}
