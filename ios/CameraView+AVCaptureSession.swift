//
//  CameraView+AVCaptureSession.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 30/8/23.
//

import Foundation
import AVFoundation

extension CameraView {
  
  final func configureCaptureSession() {
    ReactLogger.log(level: .info, message: "Configuring Session...")
    isReady = false
    
    #if targetEnvironment(simulator)
      ReactLogger.log(level: .error, message: "Target Environment cannot be a simulator")
      return
    #endif
    
    ReactLogger.log(level: .info, message: "Initializing Camera...")
    captureSession.beginConfiguration()
    defer {
      captureSession.commitConfiguration()
    }
    
    // Video Input
    do {
      
      ReactLogger.log(level: .info, message: "Adding Video input...")
      let videoDevice = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .unspecified)
      
      let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
      guard captureSession.canAddInput(videoDeviceInput) else {
        ReactLogger.log(level: .error, message: "Unable to add device input")
        return
      }
      print("Success!!")
      captureSession.addInput(videoDeviceInput)
    } catch {
      print("Failure")
      ReactLogger.log(level: .error, message: "Invalid video device")
      return
    }
    
    
    
  }
  
  
}
