//
//  BarcodeScanner.swift
//  BarCodeExample1
//
//  Created by Carlos Rodolfo Santos on 07/10/2017.
//  Copyright © 2017 Carlos Rodolfo Santos. All rights reserved.
//
import AVFoundation
import UIKit

extension AVMetadataObject.ObjectType {
    public static let upca: AVMetadataObject.ObjectType = AVMetadataObject.ObjectType(rawValue: "org.gs1.UPC-A")
}

class BarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate {
    
    var viewMain: ViewController!
    
    var captureSession: AVCaptureSession!
    
    
    lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    
    /// Video preview layer.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var focusView: UIView = {
        let view1 = UIView()
        view1.backgroundColor = .red
        view1.frame = CGRect(x: 0, y: (view.frame.height / 2), width: view.frame.width, height: 20)
        view1.layer.borderColor = UIColor.white.cgColor
        view1.layer.borderWidth = 2
        view1.layer.cornerRadius = 5
        view1.layer.shadowColor = UIColor.white.cgColor
        view1.layer.shadowRadius = 10.0
        view1.layer.shadowOpacity = 0.9
        view1.layer.shadowOffset = CGSize.zero
        view1.layer.masksToBounds = false
        
        return view1
    }()
    
    public var metadata = [
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.dataMatrix,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.face,
        AVMetadataObject.ObjectType.interleaved2of5,
        AVMetadataObject.ObjectType.itf14,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr,
        AVMetadataObject.ObjectType.upce,
        ]
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !metadataObjects.isEmpty else { return }
        
        guard
            let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            var code = metadataObj.stringValue,
            metadata.contains(metadataObj.type)
            else { return }
        
        
        
        var rawType = metadataObj.type.rawValue
        
        // UPC-A is an EAN-13 barcode with a zero prefix.
        // See: https://stackoverflow.com/questions/22767584/ios7-barcode-scanner-api-adds-a-zero-to-upca-barcode-format
        if metadataObj.type == AVMetadataObject.ObjectType.ean13 && code.hasPrefix("0") {
            code = String(code.dropFirst())
            rawType = AVMetadataObject.ObjectType.upca.rawValue
        }
        
        print(code)
        captureSession.stopRunning()
        
        
        viewMain.edit.text = code
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        //guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadata
        } else {
            failed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)
        
        [focusView].forEach {
            view.addSubview($0)
            view.bringSubview(toFront: $0)
        }
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
