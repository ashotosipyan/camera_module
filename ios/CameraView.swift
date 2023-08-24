//
//  CameraView.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 24/8/23.
//

import Foundation
import AVFoundation

public final class CameraView: UIView {
  
  // Capture Session
  internal let captureSession = AVCaptureSession()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented.")
  }
  
}
