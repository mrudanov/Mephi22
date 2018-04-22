//
//  StudentsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 10/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class StudentsDataSource: IStudentsDataSource {
    private struct StudentDataModel {
        var studentId: String
        var studentName: String?
    }
    
    weak var delegate: StudentsDataSourceDelegate?
    private let service: IMephi22Service
    private var students: [StudentDataModel] = []
    
    // MARK: - Initialization
    init(service: IMephi22Service) {
        self.service = service
    }
    
    // MARK: - IGroupsDataSource protocol
    func getStudentsFromGroup(_ groupId: String) {
        students = []
        service.getStudents(groupId: groupId) { [weak self] studentsResult, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let studentsResult = studentsResult else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: "No data recieved!")
                return
            }
            
            for student in studentsResult {
                var name: String?
                if let firstName = student.firstName, let lastName = student.lastName {
                    name = firstName + " " + lastName
                }
                self?.students.append(StudentDataModel(studentId: String(student.studentId), studentName: name))
            }
            self?.delegate?.studentsDidUpdate()
        }
    }
    
    func studentNameAt(_ index: Int) -> String {
        guard index < numberOfStudents() else { return "Unknown" }
        return students[index].studentName ?? "Unknown"
    }
    
    func studentIdAt(_ index: Int) -> String {
        guard index < numberOfStudents() else { return "Unknown" }
        return students[index].studentId
    }
    
    func numberOfStudents() -> Int {
        return students.count
    }
}
