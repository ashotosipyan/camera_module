import React, {useState} from 'react';
import {NativeModules, Text, TouchableOpacity, View} from 'react-native';
const {CameraModule} = NativeModules;

function App() {
  const [isCameraAvailable, setCameraAvailable] = useState(false)

  const handleOpenCamera = async () => {
    try {
      await CameraModule.openCamera()
      setCameraAvailable(true)
    } catch (error) {
      console.log('Error:', error);
    }
  };

  if (isCameraAvailable) {
    return <View/>
  }

  return (
    // eslint-disable-next-line react-native/no-inline-styles
    <View style={{flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: 'white'}}>
      <TouchableOpacity hitSlop={20} onPress={handleOpenCamera}>
        <Text>Take Photo</Text>
      </TouchableOpacity>
    </View>
  );
}

export default App;
