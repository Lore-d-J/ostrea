package com.example.ostrea

import android.content.Context
import android.os.Environment
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File
import java.util.concurrent.TimeUnit

class EspeakNgTts(private val context: Context) {
    companion object {
        init {
            try {
                // Try to load the native espeak-ng library
                System.loadLibrary("espeak-ng")
                Log.d("EspeakNgTts", "libespeak-ng loaded successfully")
            } catch (e: UnsatisfiedLinkError) {
                Log.w("EspeakNgTts", "Failed to load libespeak-ng: ${e.message}")
                Log.w("EspeakNgTts", "espeak-ng native library not found. Make sure binaries are placed in jniLibs/")
            }
        }
    }
    
    private var espeak_process: Process? = null
    private val espeak_dir: File = File(context.getExternalFilesDir(null), "espeak-ng")
    private val espeak_bin: File = File(espeak_dir, "espeak-ng")
    private val voice_dir: File = File(espeak_dir, "voices")
    private var isSpeaking = false
    private var espeakNgAvailable = false
    
    private var speechRate = 1.0f
    private var pitch = 1.0f
    private var volume = 1.0f
    private var currentLanguage = "tl"  // Tagalog/Filipino
    
    suspend fun initialize() = withContext(Dispatchers.Default) {
        try {
            Log.d("EspeakNgTts", "Initializing espeak-ng...")
            
            // Try to extract espeak-ng binaries from assets
            extractEspeakNgBinaries()
            
            // Check if espeak-ng binary exists and is executable
            if (espeak_bin.exists()) {
                // Make espeak-ng executable
                try {
                    Runtime.getRuntime().exec("chmod +x ${espeak_bin.absolutePath}").waitFor()
                    espeakNgAvailable = true
                    Log.d("EspeakNgTts", "espeak-ng initialized at: ${espeak_bin.absolutePath}")
                } catch (e: Exception) {
                    Log.e("EspeakNgTts", "Failed to set executable permission", e)
                    espeakNgAvailable = false
                }
            } else {
                Log.w("EspeakNgTts", "espeak-ng binary not found at: ${espeak_bin.absolutePath}")
                Log.w("EspeakNgTts", "Please ensure espeak-ng binaries are placed in android/app/src/main/jniLibs/")
                espeakNgAvailable = false
            }
            
            true
        } catch (e: Exception) {
            Log.e("EspeakNgTts", "Failed to initialize espeak-ng", e)
            espeakNgAvailable = false
            false
        }
    }
    
    private fun extractEspeakNgBinaries() {
        if (espeak_bin.exists()) {
            Log.d("EspeakNgTts", "espeak-ng already extracted")
            return
        }
        
        try {
            espeak_dir.mkdirs()
            voice_dir.mkdirs()
            
            // Try to extract espeak-ng from assets
            val assetManager = context.assets
            try {
                val espeakAssets = assetManager.list("espeak-ng") ?: arrayOf()
                if (espeakAssets.isNotEmpty()) {
                    for (asset in espeakAssets) {
                        val inputStream = assetManager.open("espeak-ng/$asset")
                        val outputFile = File(espeak_dir, asset)
                        inputStream.use { input ->
                            outputFile.outputStream().use { output ->
                                input.copyTo(output)
                            }
                        }
                        Log.d("EspeakNgTts", "Extracted: espeak-ng/$asset")
                    }
                } else {
                    Log.w("EspeakNgTts", "No espeak-ng assets found. Please add binaries to assets/espeak-ng/")
                }
            } catch (e: Exception) {
                Log.w("EspeakNgTts", "Could not extract espeak-ng from assets: ${e.message}")
            }
        } catch (e: Exception) {
            Log.e("EspeakNgTts", "Error creating espeak-ng directories", e)
        }
    }
    
    suspend fun speak(text: String) = withContext(Dispatchers.Default) {
        try {
            if (!espeakNgAvailable) {
                Log.e("EspeakNgTts", "espeak-ng not available")
                return@withContext false
            }
            
            if (isSpeaking) {
                stop()
            }
            
            isSpeaking = true
            
            // Calculate espeak-ng parameters
            val speed = (100 * speechRate).toInt().coerceIn(50, 200)  // 50-200 range
            val pitch_value = (50 * pitch).toInt().coerceIn(0, 100)   // 0-100 range
            val volume_value = (volume * 100).toInt().coerceIn(0, 200)  // 0-200 range
            
            // Convert language code
            val lang_code = when (currentLanguage) {
                "tl" -> "fil"  // Filipino
                "fil" -> "fil"
                else -> "fil"
            }
            
            // Build espeak-ng command
            val command = arrayOf(
                espeak_bin.absolutePath,
                "-s", (80 + (speed * 2)).toInt().toString(),
                "-p", pitch_value.toString(),
                "-a", volume_value.toString(),
                "-v", lang_code,
                text
            )
            
            Log.d("EspeakNgTts", "Speaking: $text")
            
            val process = Runtime.getRuntime().exec(command)
            espeak_process = process
            
            // Wait for completion
            val completed = process.waitFor(30, TimeUnit.SECONDS)
            if (!completed) {
                process.destroy()
                Log.w("EspeakNgTts", "espeak-ng command timed out")
            }
            
            espeak_process = null
            isSpeaking = false
            true
        } catch (e: Exception) {
            Log.e("EspeakNgTts", "Failed to speak", e)
            isSpeaking = false
            false
        }
    }
    
    fun stop() {
        try {
            if (espeak_process != null) {
                espeak_process?.destroy()
                espeak_process = null
            }
            isSpeaking = false
        } catch (e: Exception) {
            Log.e("EspeakNgTts", "Failed to stop speech", e)
        }
    }
    
    fun pause() {
        stop()
    }
    
    fun setSpeechRate(rate: Float) {
        speechRate = rate.coerceIn(0.1f, 2.0f)
    }
    
    fun setPitch(pitch_value: Float) {
        pitch = pitch_value.coerceIn(0.5f, 2.0f)
    }
    
    fun setVolume(volume_value: Float) {
        volume = volume_value.coerceIn(0f, 1.0f)
    }
    
    fun setLanguage(language: String) {
        currentLanguage = language
    }
    
    fun dispose() {
        stop()
    }
}
