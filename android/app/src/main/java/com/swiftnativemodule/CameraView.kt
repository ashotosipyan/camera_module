package com.swiftnativemodule

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import android.view.Surface
import android.widget.FrameLayout
import androidx.camera.core.Camera
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.facebook.react.bridge.ReactContext
import com.swiftnativemodule.utils.installHierarchyFitter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.guava.await
import kotlinx.coroutines.launch

class CameraView(context: Context) :
    FrameLayout(context),
    LifecycleOwner {

    private var isMounted = false
    private val reactContext: ReactContext
        get() = context as ReactContext

    @Suppress("JoinDeclarationAndAssignment")
    internal var previewView: PreviewView
    internal var camera: Camera? = null
    internal var coroutineScope = CoroutineScope(Dispatchers.Main)
    private var preview: Preview? = null
    private val lifecycleRegistry: LifecycleRegistry
    private val inputRotation: Int
        get() {
            return Surface.ROTATION_0
        }

    init {
        previewView = PreviewView(context)
        previewView.layoutParams =
            LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        previewView.installHierarchyFitter()
        addView(previewView)
        lifecycleRegistry = LifecycleRegistry(this)
        coroutineScope.launch {
            try {
                configureSession()
            } catch (e: Throwable) {
                Log.e("CameraView", "update() threw: ${e.message}")
            }
        }
    }

    override fun getLifecycle(): Lifecycle {
        return lifecycleRegistry
    }


    @SuppressLint("RestrictedApi")
    private suspend fun configureSession() {
        try {
            Log.i("CameraView", "Configuring session...")
            val cameraProvider = ProcessCameraProvider.getInstance(reactContext).await()
            var cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA
            if (ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.CAMERA
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                throw CameraPermissionError()
            }
            val previewBuilder = Preview.Builder()
                .setTargetRotation(inputRotation)

            Log.i(
                "CameraView",
                "No custom format has been set, CameraX will automatically determine best configuration..."
            )
            val aspectRatio = aspectRatio(
                previewView.height,
                previewView.width
            ) // flipped because it's in sensor orientation.
            previewBuilder.setTargetAspectRatio(aspectRatio)

            preview = previewBuilder.build()

            camera = cameraProvider.bindToLifecycle(
                this,
                cameraSelector,
                preview
            )
            preview!!.setSurfaceProvider(previewView.surfaceProvider)
        } catch (exc: Throwable) {
            Log.e("CameraView", "Failed to configure session: ${exc.message}")
        }
    }

}