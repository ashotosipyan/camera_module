package com.swiftnativemodule

abstract class CameraError(
    val domain: String,
    val id: String,
    message: String,
    cause: Throwable? = null

) : Throwable("[$domain/$id] $message", cause)

class CameraPermissionError :
    CameraError("permission", "camera-permission-denied", "The Camera permission was denied!")