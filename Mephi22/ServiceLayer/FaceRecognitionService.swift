//
//  FaceRecognitionService.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IFaceRecognitionService {
    func addFaceToGroup(image: String, groupId: String, personId: String, completionHandler: @escaping(_ error: String?) -> Void)
    func deleteFace(groupId: String, personId: String, completionHandler: @escaping(_ error: String?) -> Void)
    func deleteFacialGroup(groupId: String, completionHandler: @escaping(_ error: String?) -> Void)
    func getFacialGroups(completionHandler: @escaping([String]?, String?) -> Void)
    func getPersonsOfFacialGroup(groupId: String, completionHandler: @escaping([String]?, String?) -> Void)
    func recognizePerson(image: String, groupId: String, completionHandler: @escaping(String?, String?) -> Void)
}

struct Person: Codable {
    private enum CodingKeys : String, CodingKey {
        case faceId = "face_id"
    }
    var faceId: String
}

struct DeletedStatus: Codable {
    var status: String
}

struct FacialGroupsList: Codable {
    private enum CodingKeys : String, CodingKey {
        case status = "status", facialGroupsId = "gallery_ids"
    }
    var status: String
    var facialGroupsId: [String]
}

struct PersonsList: Codable {
    private enum CodingKeys : String, CodingKey {
        case status = "status", personsId = "subject_ids"
    }
    var status: String
    var personsId: [String]
}

struct RecognitionCandidate: Codable {
    private enum CodingKeys : String, CodingKey {
        case personId = "subject_id", confidence = "confidence"
    }
    var personId: String
    var confidence: String
}

struct RecognitionImage: Codable {
    private enum CodingKeys : String, CodingKey {
        case candidates = "candidates"
    }
    var candidates: [RecognitionCandidate]
}

struct RecognitionResult: Codable {
    private enum CodingKeys : String, CodingKey {
        case images = "images"
    }
    var images: [RecognitionImage]
}




class KairosFaceRecognitionService: IFaceRecognitionService {
    private let requestSender: IRequestSender
    
    // MARK: - Initialization
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - IFaceRecognitionService protocol
    func addFaceToGroup(image: String, groupId: String, personId: String, completionHandler: @escaping(_ error: String?) -> Void) {
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
    
    func deleteFace(groupId: String, personId: String, completionHandler: @escaping(_ error: String?) -> Void) {
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
    
    func deleteFacialGroup(groupId: String, completionHandler: @escaping(_ error: String?) -> Void) {
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
    
    func recognizePerson(image: String, groupId: String, completionHandler: @escaping(String?, String?) -> Void) {
        let request = RequestsFactory.KairosRequests.recognizeFaceRequest(image: image, gallaryId: groupId)
        requestSender.send(request: request, method: .post) { (result: Result<RecognitionResult>) in
            switch result {
            case .error(let error):
                completionHandler(nil, error)
            case .success(let recognitionResult):
                if let personId = recognitionResult.images.first?.candidates.first?.personId {
                    completionHandler(personId, nil)
                } else {
                    completionHandler(nil, "No person detected!")
                }
            }
        }
    }
    
    
}
