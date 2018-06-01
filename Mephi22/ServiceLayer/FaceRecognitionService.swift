//
//  FaceRecognitionService.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IFaceRecognitionService {
    func addFaceToGroup(image: String, groupId: String, personId: String, completionHandler: @escaping(String?) -> Void)
    
    func deleteFace(groupId: String, personId: String, completionHandler: @escaping(String?) -> Void)
    func deleteFacialGroup(groupId: String, completionHandler: @escaping(String?) -> Void)
    
    func getFacialGroups(completionHandler: @escaping([String]?, String?) -> Void)
    func getPersonsOfFacialGroup(groupId: String, completionHandler: @escaping([String]?, String?) -> Void)
    
    func recognizePerson(image: String, groupId: String, completionHandler: @escaping([(String, Float)]?, String?) -> Void)
}

class KairosFaceRecognitionService: IFaceRecognitionService {
    private let requestSender: IRequestSender
    
    // MARK: - Initialization
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - IFaceRecognitionService protocol
    func addFaceToGroup(image: String, groupId: String, personId: String, completionHandler: @escaping(String?) -> Void) {
        let request = RequestsFactory.KairosRequests.enrollRequest(subjectId: personId, image: image, gallaryId: groupId)
        requestSender.send(request: request, method: .post) { (result: Result<Person>) in
            switch result {
            case .error(let error):
                completionHandler(error)
            case .success(_):
                completionHandler(nil)
            }
        }
    }
    
    func deleteFace(groupId: String, personId: String, completionHandler: @escaping(String?) -> Void) {
        let request = RequestsFactory.KairosRequests.deletePersonRequest(subjectId: personId, gallaryId: groupId)
        requestSender.send(request: request, method: .post) { (result: Result<DeletedStatus>) in
            switch result {
            case .error(let error):
                completionHandler(error)
            case .success(_):
                completionHandler(nil)
            }
        }
    }
    
    func deleteFacialGroup(groupId: String, completionHandler: @escaping(String?) -> Void) {
        let request = RequestsFactory.KairosRequests.deleteGallaryRequest(groupId)
        requestSender.send(request: request, method: .post) { (result: Result<DeletedStatus>) in
            switch result {
            case .error(let error):
                completionHandler(error)
            case .success(_):
                completionHandler(nil)
            }
        }
    }
    
    func getFacialGroups(completionHandler: @escaping([String]?, String?) -> Void) {
        let request = RequestsFactory.KairosRequests.getGallariesRequest()
        requestSender.send(request: request, method: .post) { (result: Result<FacialGroupsList>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let facialGroupsList):
                completionHandler(facialGroupsList.facialGroupsId, nil)
            }
        }
    }
    
    func getPersonsOfFacialGroup(groupId: String, completionHandler: @escaping([String]?, String?) -> Void) {
        let request = RequestsFactory.KairosRequests.getPersonsRequest(gallaryId: groupId)
        requestSender.send(request: request, method: .post) { (result: Result<PersonsList>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let personsList):
                completionHandler(personsList.personsId, nil)
            }
        }
    }
    
    func recognizePerson(image: String, groupId: String, completionHandler: @escaping([(String, Float)]?, String?) -> Void) {
        let request = RequestsFactory.KairosRequests.recognizeFaceRequest(image: image, gallaryId: groupId)
        requestSender.send(request: request, method: .post) { (result: Result<RecognitionResult>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let recognitionResult):
                var detectedPersons: [(String, Float)] = []
                
                for image in recognitionResult.images {
                    if let personId = image.candidates?.first?.personId, let confidence = image.candidates?.first?.confidence {
                        detectedPersons.append((personId, confidence))
                    }
                }
                
                completionHandler(detectedPersons, nil)
            }
        }
    }
}
