//
//  CameraInteractor.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol ICameraInteractor {
    func addFace(image: String, studentId: String, groupId: String, completionHandler: @escaping(String?) -> Void)
    func recognizeFaces(_ images: [String], groupId: String, completionHandler: @escaping([String]) -> Void)
}

class CameraInteractor: ICameraInteractor {
    private let faceRecognitionService: IFaceRecognitionService
    
    private var faceAdded: Bool = false
    private var faceAddedToAllGroup: Bool = false
    private var addFaceError: String?
    
    private var responsesRecieved: Int = 0
    private var responsesNeeded: Int = 0
    private var recognizedPersons: [String] = []
    
    private let globalQueue = DispatchQueue(label: "ru.mephi22.counters-access")
    
    // MARK: - Initialization
    init(faceRecognitionService: IFaceRecognitionService) {
        self.faceRecognitionService = faceRecognitionService
    }
    
    // MARK: - IAFCameraInteractor protocol
    func addFace(image: String, studentId: String, groupId: String, completionHandler: @escaping(String?) -> Void) {
        self.faceAdded = false
        self.faceAddedToAllGroup = false
        
        faceRecognitionService.addFaceToGroup(image: image, groupId: groupId, personId: studentId) { [weak self] error in
            self?.addFaceError = error
            
            self?.globalQueue.async {
                self?.faceAdded = true
                self?.callAddCompletionIfNeeded(completionHandler: completionHandler)
            }
        }
        faceRecognitionService.addFaceToGroup(image: image, groupId: "all", personId: studentId) { [weak self] error in
            self?.addFaceError = error
            
            self?.globalQueue.async {
                self?.faceAddedToAllGroup = true
                self?.callAddCompletionIfNeeded(completionHandler: completionHandler)
            }
        }
    }
    
    func recognizeFaces(_ images: [String], groupId: String, completionHandler: @escaping([String]) -> Void) {
        responsesNeeded = images.count
        responsesRecieved = 0
        recognizedPersons = []
        
        for image in images {
            faceRecognitionService.recognizePerson(image: image, groupId: groupId) { [weak self] persons, error in
                self?.globalQueue.async {
                    self?.responsesRecieved += 1
                    
                    if let persons = persons {
                        self?.recognizedPersons.append(contentsOf: persons)
                    }
                    self?.callRecognitionCompletionIfNeeded(completionHandler: completionHandler)
                }
            }
        }
    }
    
    private func callAddCompletionIfNeeded(completionHandler: @escaping(String?) -> Void) {
        if faceAdded && faceAddedToAllGroup {
            completionHandler(addFaceError)
        }
    }
    
    private func callRecognitionCompletionIfNeeded(completionHandler: @escaping([String]) -> Void) {
        if responsesRecieved == responsesNeeded {
            completionHandler(recognizedPersons)
        }
    }
}
