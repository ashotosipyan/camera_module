import Foundation
import AVFoundation
import Photos
import React

@objc(CameraModule)
class CameraModule: NSObject {
  let captureSession = AVCaptureSession()
  private var imageCallback: RCTResponseSenderBlock?
  
  @objc
     static func requiresMainQueueSetup() -> Bool {
         return true
     }
  
  
  private func presentCamera(rootViewController: UIViewController) {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      rootViewController.present(imagePicker, animated: true, completion: nil)
  }
  
  var isAuthorized: Bool {
      get async {
          let status = AVCaptureDevice.authorizationStatus(for: .video)
          
          // Determine if the user previously authorized camera access.
          var isAuthorized = status == .authorized
          
          // If the system hasn't determined the user's authorization status,
          // explicitly prompt them for approval.
          if status == .notDetermined {
              isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
          }
          
          return isAuthorized
      }
  }
  
  func setUpCaptureSession(resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) async {
      guard await isAuthorized else {
        reject("AUTH_ERROR", "User not authorized to use camera", nil)
        return
      }
      
      captureSession.beginConfiguration()
      let videoDevice = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back)
      guard
          let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
          captureSession.canAddInput(videoDeviceInput)
          else {
            reject("CAMERA_SETUP_ERROR", "Unable to configure capture session", nil)
            return
          }
    
      captureSession.addInput(videoDeviceInput)
    
      resolve(nil)
  }
  
  @objc func openCamera(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject:@escaping RCTPromiseRejectBlock) {
    Task {
      await setUpCaptureSession(resolve: resolve, rejecter: reject)
    }
  }
  
}

extension CameraModule: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    picker.dismiss(animated: true, completion: nil)
    if let image = info[.originalImage] as? UIImage {
      guard let imageUrl = saveImageToCameraRoll(image: image) else {
        imageCallback?(["E_IMAGE_SAVE_FAILED"])
        return
      }
      imageCallback?([NSNull(), imageUrl])
    } else {
      imageCallback?(["E_IMAGE_CAPTURE_FAILED"])
    }
  }

  private func saveImageToCameraRoll(image: UIImage) -> String? {
    var imageUrl: String?
    PHPhotoLibrary.shared().performChanges({
      let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
      let placeholder = request.placeholderForCreatedAsset
      imageUrl = placeholder?.localIdentifier
    }, completionHandler: { success, error in
      if !success {
        imageUrl = nil
      }
    })
    return imageUrl
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    imageCallback?(["E_IMAGE_CAPTURE_CANCELLED"])
  }
}
