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
                        val language = call.argument<String>("language") ?: "fil"
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
                        val language = call.argument<String>("language") ?: "fil"
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
                    setLanguage("fil")  // Default to Tagalog
                    selectBestVoice()  // Automatically select the best available voice
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
                "en-US" -> Locale("en", "US")
                "en-GB" -> Locale("en", "GB")
                else -> Locale(language)
            }
            tts?.language = locale
        }
    }

    private fun selectBestVoice() {
        if (tts != null && isTtsReady) {
            val voices = tts?.voices ?: emptySet()
            var bestVoice: android.speech.tts.Voice? = null

            // Prioritize voices with "neural", "wavenet", or high quality
            for (voice in voices) {
                if (voice.name.contains("neural", ignoreCase = true) ||
                    voice.name.contains("wavenet", ignoreCase = true) ||
                    voice.quality == android.speech.tts.Voice.QUALITY_VERY_HIGH) {
                    // Prefer Tagalog voices, but accept English if better quality
                    if (voice.locale.language == "fil" || voice.locale.language == "tl") {
                        bestVoice = voice
                        break  // Found a good Tagalog voice
                    } else if (bestVoice == null || voice.quality > bestVoice.quality) {
                        bestVoice = voice
                    }
                }
            }

            // If no high-quality voice found, pick the first available
            if (bestVoice == null && voices.isNotEmpty()) {
                bestVoice = voices.first()
            }

            // Set the selected voice
            if (bestVoice != null) {
                tts?.voice = bestVoice
            }
        }
    }

    override fun onDestroy() {
        tts?.shutdown()
        super.onDestroy()
    }
}

