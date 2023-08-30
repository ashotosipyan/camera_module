//
//  CameraQueues.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 30/8/23.
//

import Foundation

@objc
public class CameraQueues: NSObject {
  /// The serial execution queue for the camera preview layer (input stream) as well as output processing of photos.
  @objc public static let cameraQueue = DispatchQueue(label: "manomano/VisionCamera.main",
                                                      qos: .userInteractive,
                                                      attributes: [],
                                                      autoreleaseFrequency: .inherit,
                                                      target: nil)
}
