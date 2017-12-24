//
//  FaceRecognitionResponseModels.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

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
    var confidence: Float
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
