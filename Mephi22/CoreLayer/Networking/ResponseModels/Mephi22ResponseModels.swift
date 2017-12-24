//
//  Mephi22ResponseModels.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

struct Group: Codable {
    private enum CodingKeys : String, CodingKey {
        case groupId = "group_id", groupName = "group_name"
    }
    var groupId: Int
    var groupName: String?
}

struct Student: Codable {
    private enum CodingKeys : String, CodingKey {
        case studentId = "id", firstName = "first_name", lastName = "last_name"
    }
    var studentId: Int
    var firstName: String?
    var lastName: String?
}
