package com.rbmelolima.pdf_viewer

import android.os.Environment
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
                else -> {
                    result.notImplemented()
                }
            }
        }
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
}
