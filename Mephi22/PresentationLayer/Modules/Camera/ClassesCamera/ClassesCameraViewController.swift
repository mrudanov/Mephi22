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
    
    private var cameraInteractor: ICameraInteractor?
    
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
    public static func initVC(classNumber: String, groupId: String, cameraInteractor: ICameraInteractor) -> ClassesCameraViewController {
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
        
        guard let cgImage = photo.cgImageRepresentation()?.takeUnretainedValue() else { return }
        
        var image = UIImage()
        
        if currentCameraIsBack {
            image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
        } else {
            image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let base64Image = imageData.base64EncodedString()
            photos.append(base64Image)
        }
    }
    
    private func recognizeFaces() {
        guard let groupId = groupId else { return }
        
        HUD.show(.progress)
        cameraInteractor?.recognizeFaces(photos, groupId: groupId, completionHandler: recognizeComplition)
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
        if photos.count != 0 {
            super.stopRunningCaptureSession()
            recognizeFaces()
        }
    }
    
    @IBAction func takePictureButtonPressed(_ sender: RoundedUIButton) {
        super.takePhoto()
    }
    
    // MARK: - Complitions
    private func recognizeComplition(personIds: [(String, Float)]) {
        DispatchQueue.main.async { [weak self] in
            HUD.hide()
            guard personIds.count != 0 else {
                self?.showAllert(with: "No faces recognized", tryAgainAction: {
                    self?.recognizeFaces()
                })
                return
            }
            
            HUD.flash(.success)
            self?.navigateToCheckPredictions(presonIds: personIds)
        }
    }
    
    // MARK: - Navigation
    private func navigateToCheckPredictions(presonIds: [(String, Float)]) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let checkAssembly = appDelegate!.rootAssembly.checkPredictionsAssembly
        if let groupId = groupId {
            let destinationViewController = checkAssembly.checkPredictionsViewController(recognizedStudents: presonIds, groupId: groupId)
            appDelegate?.rootAssembly.mainNavigationController.show(destinationViewController, sender: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Alerts
    private func showAllert(with message: String, tryAgainAction: @escaping() -> Void) {
        let alert = UIAlertController(title: "Recognizing face error", message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: { _ in
            tryAgainAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            super.startRunningCaptureSession()
            self.photos = []
        }
        
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
