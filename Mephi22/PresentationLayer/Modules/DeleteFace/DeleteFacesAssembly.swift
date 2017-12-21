//
//  DeleteFacesAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 21/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class DeleteFacesAssembly {
    private let mephi22Service: IMephi22Service
    
    init(mephi22Service: IMephi22Service) {
        self.mephi22Service = mephi22Service
    }
    
    func deleteFacesViewController() -> DeleteFacesViewController {
        let studentsDataSource = StudentsDataSource(service: mephi22Service)
        let groupsDataSource = GroupsDataSource(service: mephi22Service)
        
        return DeleteFacesViewController.initVC(groupsDataSource: groupsDataSource, studentsDataSource: studentsDataSource)
    }
}
