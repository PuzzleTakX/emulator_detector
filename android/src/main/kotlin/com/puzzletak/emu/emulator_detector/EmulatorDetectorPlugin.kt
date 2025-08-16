package com.puzzletak.emu.emulator_detector

import android.content.Context
import android.util.Log
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class EmulatorDetectorPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "emulator_detector")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
        "isEmulator" -> result.success(isEmulator(context))
        "getEmulatorChecks" -> {
            val checks = getEmulatorChecks()
            result.success(checks)
        }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    init {
      System.loadLibrary("emulator_detector")
    }
  }

  external fun checkCpuTiming(): Boolean

  private fun isEmulator(context: Context): Boolean {
    return checkTrustZone() ||
            checkCpuTiming() ||
            checkKernelFiles() ||
            checkSystemProperties()
  }

  private fun getEmulatorChecks(): HashMap<String, Any?> {
    val checks = HashMap<String, Any?>()
    checks["checkCpuTiming"] = checkCpuTiming()
    checks["checkTrustZone"] = checkTrustZone()
    checks["checkKernelFiles"] = checkKernelFiles()
    checks["checkSystemProperties"] = checkSystemProperties()
    return checks
  }


  private fun checkTrustZone(): Boolean {
    val trustZoneFiles = listOf(
      "/sys/kernel/security/tz_version",
      "/dev/tee0",
      "/sys/devices/system/cpu/cpu0/cp15/tpidrurw"
    )
    return trustZoneFiles.none { File(it).exists() }
  }

  private fun checkKernelFiles(): Boolean {
    val kernelFiles = listOf(
      "/proc/self/maps" to "qemu",
      "/proc/cpuinfo" to "BogoMIPS\\s*:\\s*0.00"
    )
    for ((filePath, keyword) in kernelFiles) {
      val file = File(filePath)
      if (file.exists()) {
        val content = file.readText()
        if (keyword.contains("BogoMIPS")) {
          val regex = Regex(keyword)
          if (regex.containsMatchIn(content)) return true
        } else if (content.contains(keyword, ignoreCase = true)) {
          return true
        }
      }
    }
    return false
  }

  private fun checkSystemProperties(): Boolean {
    val qemuProp = getSystemProperty("ro.kernel.qemu", "0")
    val bootProp = getSystemProperty("ro.boot.hardware", "")
    val secureProp = getSystemProperty("ro.secure", "1")
    return qemuProp == "1" || bootProp.containsAny("goldfish", "ranchu") || secureProp != "1"
  }

  private fun getSystemProperty(key: String, defaultValue: String = ""): String {
    return try {
      val clazz = Class.forName("android.os.SystemProperties")
      val method = clazz.getMethod("get", String::class.java, String::class.java)
      method.invoke(null, key, defaultValue) as String
    } catch (e: Exception) {
      defaultValue
    }
  }

  private fun String.containsAny(vararg substrings: String): Boolean {
    return substrings.any { this.contains(it, ignoreCase = true) }
  }
}
