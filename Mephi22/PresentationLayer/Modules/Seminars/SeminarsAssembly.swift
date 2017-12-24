//
//  SeminarsAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class SeminarsAssembly {
    private let faceRecognitionService: IFaceRecognitionService
    private let mephi22Service: IMephi22Service
    
    init(mephi22Service: IMephi22Service, faceRecognitionService: IFaceRecognitionService) {
        self.faceRecognitionService = faceRecognitionService
        self.mephi22Service = mephi22Service
    }
    
    func seminarsSelectGroupViewController() -> SeminarsSelectGroupViewController {
        let groupsDataSource = EnrolledGroupsDataSource(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        
        return SeminarsSelectGroupViewController.initVC(groupsDataSource: groupsDataSource)
    }
}
