import React, {useEffect, useRef} from 'react';
import {
  findNodeHandle,
  PixelRatio,
  requireNativeComponent,
  UIManager,
} from 'react-native';

export const CameraView = requireNativeComponent('CameraView');

const createFragment = viewId => {
  console.log('-> viewId', viewId);
  UIManager.dispatchViewManagerCommand(
    viewId,
    // we are calling the 'create' command
    UIManager.getViewManagerConfig(
      'CameraViewManager',
    ).Commands.create.toString(),
    [viewId],
  );
};

function App() {
  const ref = useRef(null);

  useEffect(() => {
    const viewId = findNodeHandle(ref.current);
    createFragment(viewId);
  }, []);

  return (
    <CameraView
      style={{
        flex: 1,
        backgroundColor: 'red',
      }}
      ref={ref}
    />
  );
}

export default App;
