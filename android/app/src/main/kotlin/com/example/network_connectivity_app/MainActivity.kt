// android/app/src/main/kotlin/com/example/flutter_network_app/MainActivity.kt

package com.example.network_connectivity_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.net.wifi.WifiManager
import android.net.ConnectivityManager
import android.os.Build
import android.annotation.SuppressLint

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_network_app/network"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isWifiEnabled" -> {
                    result.success(isWifiEnabled())
                }
                "isMobileDataEnabled" -> {
                    result.success(isMobileDataEnabled())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun isWifiEnabled(): Boolean {
        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        return wifiManager.isWifiEnabled
    }
    
    @SuppressLint("MissingPermission")
    private fun isMobileDataEnabled(): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // For newer Android versions
            val networks = connectivityManager.allNetworks
            for (network in networks) {
                val capabilities = connectivityManager.getNetworkCapabilities(network)
                if (capabilities != null) {
                    if (capabilities.hasTransport(android.net.NetworkCapabilities.TRANSPORT_CELLULAR)) {
                        return true
                    }
                }
            }
            return false
        } else {
            // For older Android versions
            try {
                val method = ConnectivityManager::class.java.getDeclaredMethod("getMobileDataEnabled")
                method.isAccessible = true
                return method.invoke(connectivityManager) as Boolean
            } catch (e: Exception) {
                return false
            }
        }
    }
}