//
//  CameraViewManager.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 24/8/23.
//

import AVFoundation
import Foundation

@objc(CameraViewManager)
final class CameraViewManager: RCTViewManager {
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override final func view() -> UIView! {
    return CameraView()
  }
  
  @objc
  final func getCameraPermissionStatus(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    withPromise(resolve: resolve, reject: reject) {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      return status
    }
  }
  
  @objc
  final func requestCameraPermission(_ resolve: @escaping RCTPromiseResolveBlock, reject _: @escaping RCTPromiseRejectBlock) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      let result: AVAuthorizationStatus = granted ? .authorized : .denied
      resolve(result)
    }
  }
}
