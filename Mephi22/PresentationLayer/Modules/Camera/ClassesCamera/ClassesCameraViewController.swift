//
//  ClassesCameraViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import AVFoundation
import UIKit
import PKHUD

class ClassesCameraViewController: CameraViewController {
    private var classNumber: String?
    private var groupId: String?
    private var photos: [String] = []
    private var currentCameraIsBack: Bool = true
    
    private var cameraInteractor: IAFCameraInteractor?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.defaultCameraIsBack = true
        super.viewDidLoad()
        
        currentCameraIsBack = true
        doneButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        flipCameraButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    // MARK: - Initialization
    public static func initVC(classNumber: String, groupId: String, cameraInteractor: IAFCameraInteractor) -> ClassesCameraViewController {
        let cameraVC = UIStoryboard(name: "ClassesCamera", bundle: nil).instantiateViewController(withIdentifier: "ClassesCamera") as! ClassesCameraViewController
        
        cameraVC.classNumber = classNumber
        cameraVC.groupId = groupId
        cameraVC.cameraInteractor = cameraInteractor
        return cameraVC
    }
    
    // MARK: - Photo output
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            let base64Image = imageData.base64EncodedString()
            photos.append(base64Image)
        }
    }
    
    private func recognizeFaces() {
        guard let classNumber = classNumber, let groupId = groupId else { return }
        
        HUD.show(.progress)
//        cameraInteractor?.addFace(image: image, studentId: studentId, groupId: groupId, completionHandler: addFaceComplition)
    }
    
    // MARK: - Controls buttons
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func flipButtonPressed(_ sender: UIButton) {
        var angle = CGFloat()
        
        if currentCameraIsBack {
            angle = 0
        } else {
            angle = CGFloat.pi / 2
        }
        
        doneButton.transform = CGAffineTransform(rotationAngle: angle)
        flipCameraButton.transform = CGAffineTransform(rotationAngle: angle)
        
        currentCameraIsBack = !currentCameraIsBack
        super.flipCamera()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        super.stopRunningCaptureSession()
    }
    
    @IBAction func takePictureButtonPressed(_ sender: RoundedUIButton) {
        super.takePhoto()
    }
    
    // MARK: - Complitions
    private func addFaceComplition(error: String?) {
        DispatchQueue.main.async { [weak self] in
            HUD.hide()
            
            if let error = error {
                print(error)
                self?.showAllert(with: error, tryAgainAction: {
                    self?.recognizeFaces()
                })
            } else {
                HUD.flash(.success)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Alerts
    private func showAllert(with message: String, tryAgainAction: @escaping() -> Void) {
        let alert = UIAlertController(title: "Adding face error", message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: { (action) in
            tryAgainAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
