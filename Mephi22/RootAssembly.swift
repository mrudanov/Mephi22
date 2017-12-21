//
//  RootAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import UIKit


class RootAssembly {
    private let mephi22Service: IMephi22Service
    private let requestSender: IRequestSender
    
    init() {
        requestSender = RequestSender()
        mephi22Service = Mephi22Service(requestSender: requestSender)
        addFaceAssembly = AddFaceAssembly(mephi22Service: mephi22Service)
        deleteFacesAssembly = DeleteFacesAssembly(mephi22Service: mephi22Service)
        menuAssembly = MenuAssembly()
        mainNavigationController = menuAssembly.menuNavigationController()
    }
    
    let mainNavigationController: UINavigationController
    let addFaceAssembly: AddFaceAssembly
    let menuAssembly: MenuAssembly
    let deleteFacesAssembly: DeleteFacesAssembly
}
