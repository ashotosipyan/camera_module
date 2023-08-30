import {PureComponent} from 'react';
import {CameraProps} from './CameraProps';
import {NativeModules} from 'react-native';

const CameraModule = NativeModules.CameraView;

export type CameraPermissionStatus =
  | 'authorized'
  | 'denied'
  | 'not-determined'
  | 'restricted';
export type CameraPermissionRequestResult = 'authorized' | 'denied';

export class Camera extends PureComponent<CameraProps> {
  constructor(props: CameraProps) {
    super(props);
  }

  /**
   * Get a list of all available camera devices on the current phone.
   *
   * @throws {@linkcode CameraRuntimeError} When any kind of error occurred while getting all available camera devices. Use the {@linkcode CameraRuntimeError.code | code} property to get the actual error
   * @example
   * ```ts
   * const devices = await Camera.getAvailableCameraDevices()
   * const filtered = devices.filter((d) => matchesMyExpectations(d))
   * const sorted = devices.sort(sortDevicesByAmountOfCameras)
   * return {
   *   back: sorted.find((d) => d.position === "back"),
   *   front: sorted.find((d) => d.position === "front")
   * }
   * ```
   */
  /**
   * Gets the current Camera Permission Status. Check this before mounting the Camera to ensure
   * the user has permitted the app to use the camera.
   *
   * To actually prompt the user for camera permission, use {@linkcode Camera.requestCameraPermission | requestCameraPermission()}.
   *
   * @throws {@linkcode CameraRuntimeError} When any kind of error occurred while getting the current permission status. Use the {@linkcode CameraRuntimeError.code | code} property to get the actual error
   */
  public static async getCameraPermissionStatus(): Promise<CameraPermissionStatus> {
    try {
      return await CameraModule.getCameraPermissionStatus();
    } catch (e) {
      throw new Error();
    }
  }

  public static async requestCameraPermission(): Promise<CameraPermissionRequestResult> {
    try {
      return await CameraModule.requestCameraPermission();
    } catch (e) {
      throw new Error();
    }
  }
}
