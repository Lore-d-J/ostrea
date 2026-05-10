/// Text-to-Speech Service Usage Example
///
/// This service provides optimized text-to-speech functionality for Filipino/Tagalog content
/// in offline Flutter applications. It uses flutter_tts with custom optimizations for
/// natural-sounding speech.
///
/// Key Features:
/// - Optimized for Filipino/Tagalog speech only
/// - Female voice preference when available
/// - Slower speech rate (0.43) for better comprehension
/// - Natural pacing without SSML markup
///
/// Usage:
/// ```dart
/// import 'package:ostrea/services/text_to_speech_service.dart';
///
/// final tts = TextToSpeechService();
///
/// // Initialize (call once)
/// await tts.initialize();
///
/// // Speak Tagalog text with optimizations
/// await tts.speakTagalog('Kumusta ka? Maganda ang araw ngayon.');
///
/// // Control playback
/// await tts.stop();
/// await tts.pause();
///
/// // Cleanup when done
/// tts.dispose();
/// ```
///
/// Configuration Details:
/// - Language: fil-PH (Filipino Philippines)
/// - Speech Rate: 0.43 (slower for clarity)
/// - Pitch: 1.05 (slightly higher for female-like sound)
/// - Volume: 0.8 (comfortable level)
/// - Voice: Prefers female Filipino voices
///
/// This creates more natural-sounding speech for Filipino content.