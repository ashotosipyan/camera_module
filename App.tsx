import React from 'react';
import {Text, TouchableOpacity, View} from 'react-native';
import {useCameraPermissions} from './src/Camera/hooks/useCameraPermissions.hook';
import {Camera} from './src/Camera/Camera';

function App() {
  const isAuthorized = useCameraPermissions();

  if (!isAuthorized) {
    return (
      <View
        style={{
          flex: 1,
          justifyContent: 'center',
          alignItems: 'center',
          backgroundColor: 'white',
        }}>
        <TouchableOpacity hitSlop={20} onPress={() => {}}>
          <Text>Take Photo</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return <Camera style={{flex: 1}} />;
}

export default App;
