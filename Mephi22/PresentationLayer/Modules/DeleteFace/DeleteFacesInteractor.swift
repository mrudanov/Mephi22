//
//  DeleteFacesInteractor.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 23/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IDeleteFaceInteractor {
    func deleteStudentFromRecognizer(_ studentId: String, groupId: String, completionHandler: @escaping(String?) -> Void)
    func daleteGroupFromRecognizer(_ groupId: String, completionHandler: @escaping(_ error: String?) -> Void)
}

class DeleteFaceInteractor:IDeleteFaceInteractor {
    private let faceRecognitionService: IFaceRecognitionService
    
    // MARK: - Initialization
    init(faceRecognitionService: IFaceRecognitionService) {
        self.faceRecognitionService = faceRecognitionService
    }
    
    // MARK: - IDeleteFaceInteractor protocol
    func deleteStudentFromRecognizer(_ studentId: String, groupId: String, completionHandler: @escaping (String?) -> Void) {
        faceRecognitionService.deleteFace(groupId: groupId, personId: studentId, completionHandler: completionHandler)
    }
    
    func daleteGroupFromRecognizer(_ groupId: String, completionHandler: @escaping (String?) -> Void) {
        faceRecognitionService.deleteFacialGroup(groupId: groupId, completionHandler: completionHandler)
    }
}
