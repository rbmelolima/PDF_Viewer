package com.rbmelolima.pdf_viewer

import android.content.Intent
import android.net.Uri
import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.Settings
import android.util.Log
import com.rbmelolima.pdf_viewer.custom_exceptions.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val channel = "native.flutter/directory"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "getRootPaths" -> {
                    result.success(getRootPaths())
                }
                "getAllFiles" -> {
                    result.success(getAllFiles(call.arguments as String))
                }
                "getAllFilesExtended" -> {
                    try {
                        result.success(getAllFilesExtended(call.arguments as String))
                    } catch(e: PermissionDeniedException) {
                        result.error("PERMISSION_DENIED", e.message, null)
                    } catch(e: AndroidVersionException) {
                        result.error("ANDROID_VERSION", e.message, null)
                    } catch(e: Exception) {
                        result.error("GENERIC_ERROR", e.message, null)
                    }
                }
                "redirectToSettings" -> {
                    result.success(redirectToSettings())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun redirectToSettings() {
        if (SDK_INT < 30) {
            throw AndroidVersionException("This method is only available for Android 11 or higher")
        }

        val uri = Uri.parse("package:${BuildConfig.APPLICATION_ID}")

        startActivity(
            Intent(
                Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                uri
            )
        )

    }

    private fun getSDCardRoot() : String? {
        val appsDir: Array<File> = context.getExternalFilesDirs(null)
        val extRootPaths: ArrayList<String> = ArrayList()

        for (file: File in appsDir)
            extRootPaths.add(file.absolutePath)

        if(extRootPaths.size > 1) {
           val sdCardPath = extRootPaths[1]
           val splittedPath = sdCardPath.split("/")
            return  "/" + splittedPath[1] + "/" + splittedPath[2]
        }

        return null
    }

    /// Search all device root directories
    private fun getRootPaths(): List<String> {
        val listOfPaths: MutableList<String> = mutableListOf()
        val root = Environment.getExternalStorageDirectory()
        val listOfFiles = root.listFiles()

        if(listOfFiles != null) {
            for(file in listOfFiles) {
                listOfPaths.add(file.absolutePath)
            }
        }

        return listOfPaths
    }

    private fun getAllFiles(typeFile: String): List<String> {
        val sdCardRootPath: String? = getSDCardRoot()
        val deviceRootPath = Environment.getExternalStorageDirectory()
        val listOfPaths: MutableList<String> = mutableListOf()

        deviceRootPath.walk().forEach {
            if(it.isFile && it.extension == typeFile) {
                listOfPaths.add(it.absolutePath)
            }
        }

        if(sdCardRootPath != null) {
            val sdCard = File(sdCardRootPath)
            sdCard.walk().forEach {
                if(it.isFile && it.extension == typeFile) {
                    listOfPaths.add(it.absolutePath)
                }
            }
        }

        return listOfPaths
    }

    private fun getAllFilesExtended(typeFile: String): List<HashMap<String, String>> {
        if(SDK_INT < 30) {
            throw AndroidVersionException("This method is only available for Android 11 or higher")
        }

        val sdCardRootPath: String? = getSDCardRoot()
        val deviceRootPath = Environment.getExternalStorageDirectory()
        val listOfPaths: MutableList<HashMap<String, String>> = mutableListOf()

        val hasPermission: Boolean = Environment.isExternalStorageManager()

        if(!hasPermission) {
            Log.v("watch", "Permission denied")
            throw PermissionDeniedException("Permission denied")
        }

        deviceRootPath.walk().forEach {
            if(it.isFile && it.extension == typeFile) {
                listOfPaths.add(
                    hashMapOf(
                        "name" to it.name,
                        "path" to it.absolutePath,
                        "lastModified" to it.lastModified().toString(),
                        "size" to it.length().toString()
                    )
                )
            }
        }

        if(sdCardRootPath != null) {
            val sdCard = File(sdCardRootPath)
            sdCard.walk().forEach {
                if(it.isFile && it.extension == typeFile) {
                    listOfPaths.add(
                        hashMapOf(
                            "name" to it.name,
                            "path" to it.absolutePath,
                            "lastModified" to it.lastModified().toString(),
                            "size" to it.length().toString()
                        )
                    )
                }
            }
        }

        return listOfPaths
    }
}



