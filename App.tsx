import React from 'react';
import {Text, TouchableOpacity, View} from 'react-native';
import {useCameraPermissions} from './src/Camera/hooks/useCameraPermissions.hook';
import {Camera} from './src/Camera/Camera';
import {isAndroid} from './src/utils';

function App() {
  const isAuthorized = useCameraPermissions();

  if (!isAuthorized && !isAndroid()) {
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

  return isAndroid() ? (
    <View>
      <TouchableOpacity
        onPress={() => Camera.testEvent()}
        style={{padding: 20, backgroundColor: 'yellow'}}>
        <Text style={{color: 'black'}}>Press android</Text>
      </TouchableOpacity>
    </View>
  ) : (
    <Camera style={{flex: 1}} />
  );
}

export default App;
