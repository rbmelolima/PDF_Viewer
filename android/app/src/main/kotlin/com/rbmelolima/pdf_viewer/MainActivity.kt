package com.rbmelolima.pdf_viewer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.os.Environment
import android.util.Log
import android.provider.MediaStore.Files

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
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getRootPaths(): List<String> {
        val listOfPaths: MutableList<String> = mutableListOf()

        Log.v("native", Environment.getExternalStorageDirectory().absolutePath)
        val root = Environment.getExternalStorageDirectory()

        val list = root.list()

        if(list != null) {
            for (path in list) {
                listOfPaths.add("${root.absolutePath}/$path")
            }
        }

        return listOfPaths
    }
}
