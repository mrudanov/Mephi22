//
//  CameraAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class CameraAssembly {
    private let faceRecognitionService: IFaceRecognitionService
    
    init(faceRecognitionService: IFaceRecognitionService) {
        self.faceRecognitionService = faceRecognitionService
    }
    
    func addFacesCameraViewController(groupId: String, studentId: String) -> AFCameraViewController {
        let cameraInteractor: IAFCameraInteractor = AFCameraInteractor(faceRecognitionService: faceRecognitionService)
        
        return AFCameraViewController.initVC(studentId: studentId, groupId: groupId, cameraInteractor: cameraInteractor)
    }
    
    func classesCameraViewController(classNumber: String, groupId: String) -> ClassesCameraViewController {
        let cameraInteractor: IAFCameraInteractor = AFCameraInteractor(faceRecognitionService: faceRecognitionService)
        
        return ClassesCameraViewController.initVC(classNumber: classNumber, groupId: groupId, cameraInteractor: cameraInteractor)
    }
}
