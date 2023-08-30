//
//  AVAuthorizationStatus+descriptor.swift
//  SwiftNativeModule
//
//  Created by Daniel Benet on 30/8/23.
//

import AVFoundation

extension AVAuthorizationStatus {
  var descriptor: String {
    switch self {
    case .authorized:
      return "authorized"
    case .denied:
      return "denied"
    case .notDetermined:
      return "not-determined"
    case .restricted:
      return "restricted"
    @unknown default:
      fatalError("AVAuthorizationStatus has unknown state.")
    }
  }
}
