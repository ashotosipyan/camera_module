//
//  CameraView.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 24/8/23.
//

import Foundation
import AVFoundation

public final class CameraView: UIView {
    
  internal var isReady = false
    
  // Capture Session
  internal let captureSession = AVCaptureSession()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    self.configureCaptureSession()
    
    videoPreviewLayer.session = captureSession
    
    // self.captureSession.startRunning()
  }
  
  /// Convenience wrapper to get layer as its statically known type.
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    // swiftlint:disable force_cast
    return layer as! AVCaptureVideoPreviewLayer
  }

  override public class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }

  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented.")
  }
  
}
