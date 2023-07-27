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
  
  @objc func openCamera(_ callback: @escaping RCTResponseSenderBlock) {
      guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
        callback(["E_ACTIVITY_DOES_NOT_EXIST"])
        return
      }

      AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
        if success {
          self?.imageCallback = callback
          DispatchQueue.main.async {
            self?.presentCamera(rootViewController: rootViewController)
          }
        } else {
          callback(["E_CAMERA_PERMISSION_DENIED"])
        }
      }
    }
  
  private func presentCamera(rootViewController: UIViewController) {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      rootViewController.present(imagePicker, animated: true, completion: nil)
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
