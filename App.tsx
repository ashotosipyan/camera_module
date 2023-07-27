import React from 'react';
import {Pressable, Text, View} from 'react-native';
import CameraModuleWrapper from './CameraModule';

function App() {
  const handleTakePhoto = async () => {
    try {
      const imageUri = await CameraModuleWrapper.openCamera(() => {
        console.log('hey');
      });
      console.log('Image URI:', imageUri);
    } catch (error) {
      console.log('Error:', error);
    }
  };
  return (
    // eslint-disable-next-line react-native/no-inline-styles
    <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
      <Pressable onPress={handleTakePhoto}>
        <Text>Take Photo</Text>
      </Pressable>
    </View>
  );
}

export default App;
