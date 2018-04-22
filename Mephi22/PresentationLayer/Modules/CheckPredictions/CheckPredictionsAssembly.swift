//
//  CheckPredictionsAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class CheckPredictionsAssembly {
    private let mephi22Service: IMephi22Service
    private let faceRecognitionService: IFaceRecognitionService
    
    init(mephi22Service: IMephi22Service, faceRecognitionService: IFaceRecognitionService) {
        self.mephi22Service = mephi22Service
        self.faceRecognitionService = faceRecognitionService
    }
    
    func checkPredictionsViewController(recognizedStudents: [(String, Float)], groupId: String) -> CheckPredictionsViewController {
        let studentsDataSource = StudentsDataSource(service: mephi22Service)
        
        return CheckPredictionsViewController.initVC(studentsDataSource: studentsDataSource, recognizedStudents: recognizedStudents, groupId: groupId)
    }
}
