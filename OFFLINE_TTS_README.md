# Offline Filipino Text-to-Speech Implementation

## Overview

This Flutter app implements **completely offline** Filipino/Tagalog text-to-speech using Android's native TTS engines. No internet connection is required for speech synthesis.

## How It Works

### Android Native TTS Engines

The implementation automatically selects the best available offline TTS engine:

1. **Google TTS** (`com.google.android.tts`) - Highest quality, works offline
2. **Samsung TTS** (`com.samsung.tts`) - Good quality on Samsung devices
3. **Pico TTS** (`com.svox.pico`) - Basic but reliable offline engine

### Filipino Language Support

- Primary locale: `tl-PH` (Tagalog/Philippines)
- Fallback locale: `fil-PH` (Filipino/Philippines)
- Automatic voice selection (prefers female voices when available)

### Speech Parameters (Optimized for Filipino)

- **Speech Rate**: 0.45 (natural flow, not too slow)
- **Pitch**: 1.0 (natural pitch)
- **Volume**: 0.9 (clear but not overwhelming)

## Platform Channel Communication

### Flutter → Android

```dart
// Initialize TTS
await platform.invokeMethod('initialize');

// Speak text
await platform.invokeMethod('speak', {
  'text': 'Hello world',
  'language': 'tl'
});

// Stop speaking
await platform.invokeMethod('stop');

// Pause speaking
await platform.invokeMethod('pause');

// Clean up
await platform.invokeMethod('dispose');
```

### Android → Flutter

- Success/failure callbacks via `MethodChannel.Result`
- Logging via Android Logcat for debugging

## Files Modified

### Android Implementation
- `android/app/src/main/kotlin/com/example/ostrea/MainActivity.kt`
  - Platform channel handler
  - TTS engine selection and initialization
  - Filipino voice selection

### Flutter Implementation
- `lib/services/text_to_speech_service.dart`
  - Singleton service class
  - Platform channel communication
  - Error handling

## Testing Offline Functionality

1. **Disable internet** on your Android device
2. **Install the APK**:
   ```bash
   flutter build apk --debug
   flutter install
   ```
3. **Test speech** - should work without internet
4. **Check logs** in Android Studio or `flutter logs`

## Device Requirements

### TTS Data Installation
Some devices require manual TTS data installation:

1. Go to **Settings → Accessibility → Text-to-Speech Output**
2. Select **Google Text-to-Speech Engine**
3. Tap **Install voice data**
4. Download **Filipino** language pack

### Supported Android Versions
- **Minimum**: API 21 (Android 5.0)
- **Recommended**: API 23+ (Android 6.0+) for best voice quality

## Troubleshooting

### "TTS not working"
- Check if TTS data is installed
- Verify Filipino language pack is downloaded
- Check Android logs: `flutter logs`

### "Robotic voice"
- Ensure Google TTS engine is selected
- Install latest TTS data updates
- Try different Android device

### "No Filipino voices"
- Install Filipino language pack in TTS settings
- Some devices may not have Filipino support

## Performance Notes

- **Initialization**: ~1-2 seconds on first use
- **Speech synthesis**: Near-instantaneous after initialization
- **Memory usage**: Minimal (~5-10MB additional)
- **Battery impact**: Low (similar to playing audio)

## Future Improvements

- Voice quality selection UI
- Multiple language support
- Speech rate/pitch customization
- Audio file caching for repeated phrases