import {NativeModules, Platform} from 'react-native';

const {CameraModule} = NativeModules;

const CameraModuleWrapper = {
  openCamera: (callback: any) => {
    if (Platform.OS === 'android') {
      // CameraModule.openCamera(callback);
    } else if (Platform.OS === 'ios') {
      return new Promise((resolve: any, reject: any) => {
        console.log(CameraModule);
        CameraModule.openCamera(callback);
      });
    } else {
      throw new Error('E_UNSUPPORTED_PLATFORM');
    }
  },
};

export default CameraModuleWrapper;
