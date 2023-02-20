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
                "getAllFiles" -> {
                    result.success(getAllFiles(call.arguments as String))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

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
        val listOfPaths: MutableList<String> = mutableListOf()
        
        val root = Environment.getExternalStorageDirectory()

        root.walk().forEach {
            if(it.isFile && it.extension == typeFile) {
                listOfPaths.add(it.absolutePath)
            }
        }

        return listOfPaths
    }
}
