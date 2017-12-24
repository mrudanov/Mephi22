//
//  AFCameraViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import AVFoundation
import UIKit
import PKHUD

class AFCameraViewController: CameraViewController {
    private var studentId: String?
    private var groupId: String?
    private var faceImageBase64String: String?
    
    private var cameraInteractor: IAFCameraInteractor?
    
    override func viewDidLoad() {
        super.defaultCameraIsBack = false
        super.viewDidLoad()
    }
    
    // MARK: - Initialization
    public static func initVC(studentId: String, groupId: String, cameraInteractor: IAFCameraInteractor) -> AFCameraViewController {
        let cameraVC = UIStoryboard(name: "AFCamera", bundle: nil).instantiateViewController(withIdentifier: "AFCamera") as! AFCameraViewController
        
        cameraVC.studentId = studentId
        cameraVC.groupId = groupId
        cameraVC.cameraInteractor = cameraInteractor
        return cameraVC
    }
    
    // MARK: - Controls buttons
    @IBAction func flipCameraPressed(_ sender: UIButton) {
        super.flipCamera()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePictureButtonPressed(_ sender: RoundedUIButton) {
        super.takePhoto()
        super.stopRunningCaptureSession()
    }
    
    // MARK: - Photo output
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            let base64Image = imageData.base64EncodedString()
            faceImageBase64String = base64Image
            sendFace(image: base64Image)
        }
    }
    
    private func sendFace(image: String) {
        guard let studentId = studentId, let groupId = groupId else { return }
        
        HUD.show(.progress)
        cameraInteractor?.addFace(image: image, studentId: studentId, groupId: groupId, completionHandler: addFaceComplition)
    }
    
    // MARK: - Complitions
    private func addFaceComplition(error: String?) {
        DispatchQueue.main.async { [weak self] in
            HUD.hide()
            
            if let error = error {
                print(error)
                if let image = self?.faceImageBase64String {
                    self?.showAllert(with: error, tryAgainAction: {
                        self?.sendFace(image: image)
                    })
                }
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
