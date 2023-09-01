package com.swiftnativemodule

import android.Manifest
import android.annotation.SuppressLint
import android.widget.FrameLayout
import androidx.lifecycle.LifecycleOwner
import androidx.core.content.ContextCompat
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Camera
import android.util.Log
import android.view.Surface
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import java.util.concurrent.ExecutorService
import androidx.camera.view.PreviewView
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleRegistry
import com.facebook.react.bridge.ReactContext
import kotlinx.coroutines.*

class CameraView(context: Context, private val frameProcessorThread: ExecutorService) :
    FrameLayout(context),
    LifecycleOwner {

    private var isMounted = false
    private val reactContext: ReactContext
        get() = context as ReactContext

    @Suppress("JoinDeclarationAndAssignment")
    internal val previewView: PreviewView
    internal var camera: Camera? = null
    private var preview: Preview? = null
    private val lifecycleRegistry: LifecycleRegistry
    private val inputRotation: Int
        get() {
            return Surface.ROTATION_0
        }

    init {
        previewView = PreviewView(context)
        lifecycleRegistry = LifecycleRegistry(this)
    }

    override fun getLifecycle(): Lifecycle {
        return lifecycleRegistry
    }

    @SuppressLint("RestrictedApi")
    private suspend fun configureSession() {
        try {
            Log.i("CameraView", "Configuring session...")
            val cameraProvider = ProcessCameraProvider.getInstance(reactContext).await()
            var cameraSelector = CameraSelector.Builder().byID(cameraId!!).build()
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                throw CameraPermissionError()
            }
            val previewBuilder = Preview.Builder()
                .setTargetRotation(inputRotation)

            Log.i("CameraView", "No custom format has been set, CameraX will automatically determine best configuration...")
            val aspectRatio = aspectRatio(previewView.height, previewView.width) // flipped because it's in sensor orientation.
            previewBuilder.setTargetAspectRatio(aspectRatio)

            preview = previewBuilder.build()

            camera = cameraProvider.bindToLifecycle(this, cameraSelector, preview, *useCases.toTypedArray())
        } catch ()
    }

}