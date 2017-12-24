//
//  AFCameraInteractor.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IAFCameraInteractor {
    func addFace(image: String, studentId: String, groupId: String, completionHandler: @escaping(String?) -> Void)
}

class AFCameraInteractor: IAFCameraInteractor {
    private let faceRecognitionService: IFaceRecognitionService
    
    private var faceAdded: Bool = false
    private var faceAddedToAllGroup: Bool = false
    
    private let globalQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Initialization
    init(faceRecognitionService: IFaceRecognitionService) {
        self.faceRecognitionService = faceRecognitionService
    }
    
    // MARK: - IAFCameraInteractor protocol
    func addFace(image: String, studentId: String, groupId: String, completionHandler: @escaping(String?) -> Void) {
        globalQueue.async {
            self.faceAdded = false
            self.faceAddedToAllGroup = false
        }
        
        faceRecognitionService.addFaceToGroup(image: image, groupId: groupId, personId: studentId) { [weak self] error in
            self?.globalQueue.async {
                self?.faceAdded = true
                self?.callCompletionIfNeeded(error: error, completionHandler: completionHandler)
            }
        }
        faceRecognitionService.addFaceToGroup(image: image, groupId: "all", personId: studentId) { [weak self] error in
            self?.globalQueue.async {
                self?.faceAddedToAllGroup = true
                self?.callCompletionIfNeeded(error: error, completionHandler: completionHandler)
            }
        }
    }
    
    private func callCompletionIfNeeded(error: String?, completionHandler: @escaping(String?) -> Void) {
        if faceAdded && faceAddedToAllGroup {
            completionHandler(error)
        }
    }
}
