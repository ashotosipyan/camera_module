package com.swiftnativemodule

import android.util.Log
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class CameraModule (reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext)  {
    override fun getName() = "CameraView"

    @ReactMethod fun testEvent() {
        Log.d("CameraModule", "Lets goooo")
    }
}