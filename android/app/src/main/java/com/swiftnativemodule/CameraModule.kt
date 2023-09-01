package com.swiftnativemodule

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.modules.core.PermissionAwareActivity
import com.facebook.react.modules.core.PermissionListener

class CameraModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CameraView"

    companion object {
        var RequestCode = 10

        fun parsePermissionStatus(status: Int): String {
            return when (status) {
                PackageManager.PERMISSION_DENIED -> "denied"
                PackageManager.PERMISSION_GRANTED -> "authorized"
                else -> "not-determined"
            }
        }

        const val TAG_PERF = "CameraView.performance"

        private val propsThatRequireSessionReconfiguration = arrayListOf(
            "cameraId",
            "format",
            "fps",
            "hdr",
            "lowLightBoost",
            "photo",
            "video",
            "enableFrameProcessor"
        )
        private val arrayListOfZoom = arrayListOf("zoom")
    }

    @ReactMethod
    fun testEvent() {
        Log.d("CameraModule", "Lets goooo")
    }

    @ReactMethod
    fun getCameraPermissionStatus(promise: Promise) {
        val status =
            ContextCompat.checkSelfPermission(reactApplicationContext, Manifest.permission.CAMERA)
        Log.d("Permission status", status.toString())
        promise.resolve(parsePermissionStatus(status))
    }

    @ReactMethod
    fun requestCameraPermission(promise: Promise) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            // API 21 and below always grants permission on app install
            return promise.resolve("authorized")
        }

        val activity = reactApplicationContext.currentActivity
        if (activity is PermissionAwareActivity) {
            val currentRequestCode = RequestCode++
            Log.d("Permission request", currentRequestCode.toString())
            val listener =
                PermissionListener { requestCode: Int, _: Array<String>, grantResults: IntArray ->
                    if (requestCode == currentRequestCode) {
                        val permissionStatus =
                            if (grantResults.isNotEmpty()) grantResults[0] else PackageManager.PERMISSION_DENIED
                        promise.resolve(parsePermissionStatus(permissionStatus))
                        return@PermissionListener true
                    }
                    return@PermissionListener false
                }
            activity.requestPermissions(
                arrayOf(Manifest.permission.CAMERA),
                currentRequestCode,
                listener
            )
        } else {
            promise.reject(
                "NO_ACTIVITY",
                "No PermissionAwareActivity was found! Make sure the app has launched before calling this function."
            )
        }
    }
}