package com.example.ostrea

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.speech.tts.TextToSpeech
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.ostrea.app/tts"
    private var tts: TextToSpeech? = null
    private var isTtsReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "speak" -> {
                        val text = call.argument<String>("text")
                        val language = call.argument<String>("language") ?: "en"
                        if (text != null) {
                            speak(text, language)
                        }
                        result.success(null)
                    }
                    "stop" -> {
                        tts?.stop()
                        result.success(null)
                    }
                    "pause" -> {
                        tts?.stop()
                        result.success(null)
                    }
                    "setLanguage" -> {
                        val language = call.argument<String>("language") ?: "en"
                        setLanguage(language)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        initializeTts()
    }

    private fun initializeTts() {
        if (tts == null) {
            tts = TextToSpeech(this) { status ->
                if (status == TextToSpeech.SUCCESS) {
                    isTtsReady = true
                    setLanguage("en")
                }
            }
        }
    }

    private fun speak(text: String, language: String) {
        if (tts != null && isTtsReady) {
            setLanguage(language)
            tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null)
        }
    }

    private fun setLanguage(language: String) {
        if (tts != null && isTtsReady) {
            val locale = when (language) {
                "fil" -> Locale("fil", "PH")
                "en" -> Locale.ENGLISH
                else -> Locale.ENGLISH
            }
            tts?.language = locale
        }
    }

    override fun onDestroy() {
        tts?.shutdown()
        super.onDestroy()
    }
}

