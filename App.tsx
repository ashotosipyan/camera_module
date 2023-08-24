import React, {useEffect, useState} from 'react';
import {NativeModules, Text, TouchableOpacity, View} from 'react-native';
import {Camera} from "./src/Camera/Camera";
const {CameraModule} = NativeModules;

function App() {

  useEffect(() => {

      const loadDevices = async (): Promise<void> => {
            let devices = await Camera.getCameraPermissionStatus()
            console.log("-> devices", devices);
      }

      loadDevices()
  }, []);

  return (
    // eslint-disable-next-line react-native/no-inline-styles
    <View style={{flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: 'white'}}>
      <TouchableOpacity hitSlop={20} onPress={() => {}}>
        <Text>Take Photo</Text>
      </TouchableOpacity>
    </View>
  );
}

export default App;
