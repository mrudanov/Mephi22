//
//  AddFaceAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 10/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class AddFaceAssembly {
    private let mephi22Service: IMephi22Service
    
    init(mephi22Service: IMephi22Service) {
        self.mephi22Service = mephi22Service
    }
    
    func selectStudentViewController() -> AFSelectStudentViewController {
        let studentsDataSource = StudentsDataSource(service: mephi22Service)
        let groupsDataSource = GroupsDataSource(service: mephi22Service)
        
        return AFSelectStudentViewController.initVC(groupsDataSource: groupsDataSource, studentsDataSource: studentsDataSource)
    }
}
