//
//  CameraViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 23/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import AVFoundation
import UIKit
import PKHUD

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    private var captureSession = AVCaptureSession()
    private let setupQueue = DispatchQueue.global(qos: .userInitiated)
    
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    var defaultCameraIsBack: Bool = true
    
    private var photoOutput: AVCapturePhotoOutput?
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
        setupQueue.async {
            self.setupCaptureSession()
            self.setupDevice()
            self.setupInputOutput()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
                self.startRunningCaptureSession()
                HUD.hide()
            }
        }
    }
    
    func flipCamera() {
        if currentCamera == backCamera {
            currentCamera = frontCamera
        } else {
            currentCamera = backCamera
        }
        
        cameraPreviewLayer?.removeFromSuperlayer()
        HUD.show(.progress)
        DispatchQueue.global(qos: .userInitiated).async {
            self.stopRunningCaptureSession()
            self.setupCaptureSession()
            self.setupInputOutput()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
                self.startRunningCaptureSession()
                HUD.hide()
            }
        }
    }
    
    func takePhoto() {
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    // MARK: - Setup
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = defaultCameraIsBack ? backCamera : frontCamera
    }
    
    private func setupInputOutput() {
        guard let currentCamera = currentCamera else { return }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            captureSession.addInput(captureDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        guard let cameraPreviewLayer = cameraPreviewLayer else { return }
        cameraPreviewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
    }
    
    // MARK: Status bar configuration
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
