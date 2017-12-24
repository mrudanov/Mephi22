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
    private let faceRecognitionService: IFaceRecognitionService
    private let requestSender: IRequestSender
    
    let mainNavigationController: UINavigationController
    let addFaceAssembly: AddFaceAssembly
    let menuAssembly: MenuAssembly
    let deleteFacesAssembly: DeleteFacesAssembly
    let cameraAssembly: CameraAssembly
    let classesAssembly: ClassesAssembly
    let checkPredictionsAssembly: CheckPredictionsAssembly
    
    init() {
        requestSender = RequestSender()
        
        mephi22Service = Mephi22Service(requestSender: requestSender)
        faceRecognitionService = KairosFaceRecognitionService(requestSender: requestSender)
        
        menuAssembly = MenuAssembly()
        addFaceAssembly = AddFaceAssembly(mephi22Service: mephi22Service)
        deleteFacesAssembly = DeleteFacesAssembly(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        classesAssembly = ClassesAssembly(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        cameraAssembly = CameraAssembly(faceRecognitionService: faceRecognitionService)
        checkPredictionsAssembly = CheckPredictionsAssembly(mephi22Service: mephi22Service, faceRecognitionService: faceRecognitionService)
        
        mainNavigationController = menuAssembly.menuNavigationController()
    }
}
