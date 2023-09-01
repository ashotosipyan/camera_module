package com.swiftnativemodule

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager

class CameraViewManager (reactContext: ReactApplicationContext) : ViewGroupManager<CameraView>() {

    public override fun createViewInstance(context: ThemedReactContext): CameraView {
        return CameraView(context)
    }
    override fun getName(): String {
        return TAG
    }
    companion object {
        const val TAG = "CameraView"

        val cameraViewTransactions: HashMap<CameraView, ArrayList<String>> = HashMap()

        private fun addChangedPropToTransaction(view: CameraView, changedProp: String) {
            if (cameraViewTransactions[view] == null) {
                cameraViewTransactions[view] = ArrayList()
            }
            cameraViewTransactions[view]!!.add(changedProp)
        }
    }
}