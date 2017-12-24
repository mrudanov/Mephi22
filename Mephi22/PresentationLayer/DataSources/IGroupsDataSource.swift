//
//  IGroupsDataSource.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 23/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation

protocol IGroupsDataSource {
    weak var delegate: GroupsDataSourceDelegate? { get set }
    
    func getGroups()
    func groupNameAt(_ : Int) -> String
    func groupIdAt(_ : Int) -> String
    func numberOfGroups() -> Int
}

protocol GroupsDataSourceDelegate: class {
    func groupsDidUpdate()
    func recievedGroupLoadError(errorMessage: String)
}
