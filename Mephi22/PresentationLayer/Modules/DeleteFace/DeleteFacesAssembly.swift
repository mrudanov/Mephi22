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
    private let faceRecognitionService: IFaceRecognitionService
    
    init(mephi22Service: IMephi22Service, faceRecognitionService: IFaceRecognitionService) {
        self.mephi22Service = mephi22Service
        self.faceRecognitionService = faceRecognitionService
    }
    
    func deleteFacesViewController() -> DeleteFacesViewController {
        let studentsDataSource = EnrolledStudentsDataSource(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        let groupsDataSource = EnrolledGroupsDataSource(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        let deleteFaceInteractor = DeleteFaceInteractor(faceRecognitionService: faceRecognitionService)
        
        return DeleteFacesViewController.initVC(groupsDataSource: groupsDataSource, studentsDataSource: studentsDataSource, deleteFaceInteractor: deleteFaceInteractor)
    }
}
