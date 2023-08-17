import {NativeModules, Platform} from 'react-native';

const {CameraModule} = NativeModules;

const CameraModuleWrapper = {
  openCamera: () => {
    if (Platform.OS === 'android') {
      // CameraModule.openCamera(callback);
    } else if (Platform.OS === 'ios') {
      return new Promise((resolve: any, reject: any) => {
        CameraModule.openCamera();
      });
    } else {
      throw new Error('E_UNSUPPORTED_PLATFORM');
    }
  },
};

export default CameraModuleWrapper;
