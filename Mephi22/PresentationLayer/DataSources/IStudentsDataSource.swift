//
//  IStudentsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 23/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IStudentsDataSource {
    weak var delegate: StudentsDataSourceDelegate? { get set }
    
    func getStudentsFromGroup(_ : String)
    func studentNameAt(_ : Int) -> String
    func studentIdAt(_ : Int) -> String
    func numberOfStudents() -> Int
}

protocol StudentsDataSourceDelegate: class {
    func studentsDidUpdate()
    func recievedStudentsLoadError(errorMessage: String)
}
