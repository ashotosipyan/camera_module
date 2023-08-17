import Foundation
import AVFoundation
import Photos
import React

@objc(CameraModule)
class CameraModule: NSObject {
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
  
  func setUpCaptureSession() async {
      guard await isAuthorized else { return }
      // Set up the capture session.
  }
  
  @objc func openCamera() {
    Task {
      await setUpCaptureSession()
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
