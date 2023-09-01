package com.swiftnativemodule

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext

class CameraPackage : ReactPackage {
    override fun createViewManagers(
        reactContext: ReactApplicationContext
    ) = listOf(CameraViewManager(reactContext))

    override fun createNativeModules(
        reactContext: ReactApplicationContext
    ): MutableList<NativeModule> = listOf(CameraViewModule(reactContext)).toMutableList()
}