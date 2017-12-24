//
//  EnrolledStudentsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 22/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

class EnrolledStudentsDataSource: IStudentsDataSource {
    private struct StudentDataModel {
        var studentId: String
        var studentName: String?
    }
    
    weak var delegate: StudentsDataSourceDelegate?
    
    private let mephi22Service: IMephi22Service
    private let faceRecognitionService: IFaceRecognitionService
    
    private var allStudents: [StudentDataModel] = []
    private var enrolledStudents: [StudentDataModel] = []
    
    private var allStudentsRecieved: Bool = false
    private var enrolledStudentsRecieved: Bool = false
    
    // MARK: - Initialization
    init(mephi22Service: IMephi22Service, faceRecognitionService: IFaceRecognitionService) {
        self.mephi22Service = mephi22Service
        self.faceRecognitionService = faceRecognitionService
    }
    
    // MARK: - IGroupsDataSource protocol
    func getStudentsFromGroup(_ groupId: String) {
        allStudentsRecieved = false
        enrolledStudentsRecieved = false
        
        getStudentsFromMephi22(groupId)
        getStudentsFromFaceRecognitionSystem(groupId)
    }
    
    func studentNameAt(_ index: Int) -> String {
        return enrolledStudents[index].studentName ?? "Unknown"
    }
    
    func studentIdAt(_ index: Int) -> String {
        return enrolledStudents[index].studentId
    }
    
    func numberOfStudents() -> Int {
        return enrolledStudents.count
    }
    
    // MARK: helper functions///
    private func getStudentsFromMephi22(_ groupId: String){
        mephi22Service.getStudents(groupId: groupId) { [weak self] studentsResult, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let studentsResult = studentsResult else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: "No data recieved!")
                return
            }
            
            self?.updateAllStudents(studentsResult)
        }
    }
    
    private func getStudentsFromFaceRecognitionSystem(_ groupId: String){
        faceRecognitionService.getPersonsOfFacialGroup(groupId: groupId) { [weak self] studentIds, errorMessage in
            guard errorMessage == nil else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: errorMessage!)
                return
            }
            
            guard let studentIds = studentIds else {
                self?.delegate?.recievedStudentsLoadError(errorMessage: "No data recieved!")
                return
            }
            
            self?.updateEnrolledStudents(studentIds)
        }
    }
    
    private func updateAllStudents(_ studentsToUpdate: [Student]) {
        DispatchQueue.main.async {
            self.allStudents = []
            self.allStudentsRecieved = true
            
            for student in studentsToUpdate {
                var name: String? = nil
                if let firstName = student.firstName, let secondName = student.lastName {
                    name = firstName + " " + secondName
                }
                
                self.allStudents.append(StudentDataModel(studentId: String(student.studentId), studentName: name))
            }
            
            self.joinStudents()
        }
    }
    
    private func updateEnrolledStudents(_ studentsToUpdate: [String]) {
        DispatchQueue.main.async {
            self.enrolledStudents = []
            self.enrolledStudentsRecieved = true
            
            for student in studentsToUpdate {
                self.enrolledStudents.append(StudentDataModel(studentId: student, studentName: nil))
            }
            
            self.joinStudents()
        }
    }
    
    private func joinStudents() {
        if enrolledStudentsRecieved && allStudentsRecieved {
            for i in 0..<enrolledStudents.count {
                for j in 0..<allStudents.count {
                    if allStudents[j].studentId == enrolledStudents[i].studentId {
                        enrolledStudents[i].studentName = allStudents[j].studentName
                    }
                }
            }
            
            allStudents = []
            delegate?.studentsDidUpdate()
        }
    }
}
