package com.mjohnsullivan.nomnom.nomnom

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant



class MainActivity : FlutterActivity() {

    private val channel = "com.mjohnsullivan.nomnom/gps"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
            if (call.method == "getGPS") {
                result.success(getDummyGPS())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDummyGPS() = doubleArrayOf(34.010090, -118.496948)
}
