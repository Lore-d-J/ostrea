package com.example.ostrea

import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

/**
 * MainActivity with basic Android Text-to-Speech support
 * Uses Android's default TTS engine for offline Filipino speech
 */
class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val CHANNEL = "com.example.ostrea/tts"
    private var tts: TextToSpeech? = null
    private var isInitialized = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    initializeTts()
                    result.success(null)
                }
                "speak" -> {
                    val text = call.argument<String>("text")
                    val language = call.argument<String>("language") ?: "tl"
                    if (text != null) {
                        speak(text, language)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Text is required", null)
                    }
                }
                "stop" -> {
                    stop()
                    result.success(null)
                }
                "pause" -> {
                    pause()
                    result.success(null)
                }
                "dispose" -> {
                    dispose()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun initializeTts() {
        if (tts == null) {
            tts = TextToSpeech(this, this)
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            isInitialized = true

            // Set Filipino language preferences
            val filipinoLocale = Locale("tl", "PH")
            val result = tts?.setLanguage(filipinoLocale)

            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                // Try alternative Filipino locale
                val altLocale = Locale("fil", "PH")
                tts?.setLanguage(altLocale)
                Log.w("TTS", "Filipino locale not fully supported, using alternative")
            }

            // Set speech parameters for clear Filipino speech
            tts?.setSpeechRate(0.45f)   // Natural speech rate
            tts?.setPitch(1.0f)         // Natural pitch
            // Note: Volume is controlled by Android system settings

            // Listen for speech completion
            tts?.setOnUtteranceProgressListener(object : UtteranceProgressListener() {
                override fun onStart(utteranceId: String?) {
                    Log.d("TTS", "Speech started: $utteranceId")
                }

                override fun onDone(utteranceId: String?) {
                    Log.d("TTS", "Speech completed: $utteranceId")
                }

                override fun onError(utteranceId: String?) {
                    Log.e("TTS", "Speech error: $utteranceId")
                }

                override fun onError(utteranceId: String?, errorCode: Int) {
                    Log.e("TTS", "Speech error: $utteranceId (code: $errorCode)")
                }
            })

            Log.d("TTS", "Android TTS initialized successfully")
        } else {
            Log.e("TTS", "TTS initialization failed with status: $status")
            isInitialized = false
        }
    }

    private fun speak(text: String, language: String) {
        if (!isInitialized || tts == null) {
            Log.e("TTS", "TTS not initialized, initializing now...")
            initializeTts()
            return
        }

        // Set language based on parameter
        when (language) {
            "tl", "fil" -> tts?.setLanguage(Locale("tl", "PH"))
            else -> tts?.setLanguage(Locale("tl", "PH"))
        }

        val utteranceId = System.currentTimeMillis().toString()
        Log.d("TTS", "Speaking: $text (language: $language)")
        tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, utteranceId)
    }

    private fun stop() {
        tts?.stop()
        Log.d("TTS", "Speech stopped")
    }

    private fun pause() {
        // Android TTS doesn't have pause, so we stop instead
        tts?.stop()
        Log.d("TTS", "Speech paused (stopped)")
    }

    private fun dispose() {
        tts?.shutdown()
        tts = null
        isInitialized = false
        Log.d("TTS", "TTS disposed")
    }

    override fun onDestroy() {
        dispose()
        super.onDestroy()
    }
}

