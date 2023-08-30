import {useEffect, useState} from 'react';
import {Camera} from '../Camera';

export const useCameraPermissions = () => {
  const [isAuthorized, setIsAuthorized] = useState(false);

  useEffect(() => {
    const getPermissions = async (): Promise<void> => {
      const status = await Camera.getCameraPermissionStatus();
      let authorized = status === 'authorized';
      if (!authorized) {
        const requestStatus = await Camera.requestCameraPermission();
        authorized = requestStatus === 'authorized';
      }
      setIsAuthorized(authorized);
    };

    getPermissions();
  }, []);

  return isAuthorized;
};
